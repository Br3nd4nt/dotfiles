#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_NAME="$(basename "$0")"
LOG_FILE=""
SILENT=0
DRY_RUN=0

################################################################################
# Helpers
################################################################################

log() {
  if (( SILENT )); then
    return
  fi
  echo "$@"
}

log_quiet() {
  if [[ -n "$LOG_FILE" ]]; then
    printf '%s\n' "$*" >> "$LOG_FILE"
  fi
}

report() {
  local status="$1"; shift
  local msg="$*"
  if (( SILENT )); then
    if [[ -n "$LOG_FILE" ]]; then
      printf '%s\t%s\n' "$status" "$msg" >> "$LOG_FILE" 2>/dev/null || true
    fi
    return
  fi
  case "$status" in
    OK)     log "✓ $msg" ;;
    WARN)   log "⚠ $msg" ;;
    FAIL)   log "✗ $msg" ;;
    INFO)   log "ℹ $msg" ;;
    SKIP)   log "⊘ $msg" ;;
    *)      log "$msg" ;;
  esac
  log_quiet "$status	$msg"
}

die() {
  report FAIL "$@"
  exit 1
}

usage() {
  cat <<'USAGEEOF'
Usage: setup-dotfiles.sh [OPTIONS]

Verifies and installs the dotfiles in DOTFILES_DIR.
Reports what is missing or misconfigured and stops before making destructive changes.

Options:
  -h, --help        Show this help and exit
  -q, --quiet       Only print problems; suppress OK lines
  -l, --log FILE    Append a machine-readable report to FILE
  -n, --dry-run     Show what would be done without making changes
USAGEEOF
  exit 0
}

################################################################################
# Argument parsing
################################################################################

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage ;;
    -q|--quiet) SILENT=1; shift ;;
    -l|--log)   LOG_FILE="$2"; shift 2 ;;
    -n|--dry-run) DRY_RUN=1; shift ;;
    *) die "Unknown option: $1 (try --help)" ;;
  esac
done

[[ -n "$LOG_FILE" ]] && touch "$LOG_FILE" 2>/dev/null || true

################################################################################
# OS detection
################################################################################

if [[ -f /etc/arch-release || -f /usr/lib/os-release ]]; then
  _arch_release_file="/etc/arch-release"
  [[ -f /usr/lib/os-release ]] && _arch_release_file="/usr/lib/os-release"
  if grep -qi 'arch' "$_arch_release_file" 2>/dev/null; then
    OSTYPE_TAG="arch"
  else
    OSTYPE_TAG="linux"
  fi
elif [[ "$(uname -s)" == "Darwin" ]]; then
  OSTYPE_TAG="macos"
else
  OSTYPE_TAG="linux"
fi

HOME_DIR="${HOME:-/root}"
export OSTYPE_TAG
export HOME

################################################################################
# Files to install: src (in repo) -> dest (in $HOME)
################################################################################

declare -a INSTALL_MAP=(
  "zprofile     : .zprofile"
  "zshrc        : .zshrc"
  "gitconfig    : .gitconfig"
  "gitignore_global : .gitignore_global"
)

PATCH_SCRIPT="bin/patch-${OSTYPE_TAG}.sh"

################################################################################
# Prerequisites
################################################################################

check_prereqs() {
  if ! command -v git >/dev/null 2>&1; then
    report WARN "git not found — submodule init/clone will be skipped"
  fi

  if [[ "$OSTYPE_TAG" == "arch" ]]; then
    local have_any=0
    for pkg in git zsh; do
      if command -v "$pkg" >/dev/null 2>&1; then
        have_any=1
      fi
    done
    (( have_any )) || report WARN "zsh and/or git not found — install with: sudo pacman -S zsh git"
  fi

  if [[ "$OSTYPE_TAG" != "macos" && "$PATCH_SCRIPT" != "bin/patch-macos.sh" ]]; then
    if [[ ! -x "$DOTFILES_DIR/$PATCH_SCRIPT" ]]; then
      report FAIL "patch script missing: $PATCH_SCRIPT"
      return 1
    fi
  fi

  return 0
}

################################################################################
# Submodule handling
################################################################################

init_submodules() {
  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    report SKIP "Not a git repository — skipping submodule init"
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    report SKIP "git not available — skipping submodule init"
    return 0
  fi

  if ! git -C "$DOTFILES_DIR" submodule status >/dev/null 2>&1; then
    report WARN "submodule status check failed — run: git submodule update --init --recursive"
    return 0
  fi

  local uninitialized
  uninitialized=$(git -C "$DOTFILES_DIR" submodule status 2>/dev/null | grep '^[-+]' | wc -l || true)
  if [[ "$uninitialized" -gt 0 ]]; then
    report INFO "Initializing submodules…"
    if (( DRY_RUN )); then
      report INFO "[dry-run] git -C $DOTFILES_DIR submodule update --init --recursive"
      return 0
    fi
    if git -C "$DOTFILES_DIR" submodule update --init --recursive; then
      report OK "submodules initialized"
    else
      report FAIL "submodule init failed — run manually: git submodule update --init --recursive"
    fi
  else
    report OK "submodules up to date"
  fi
}

################################################################################
# Backup existing dotfiles
################################################################################

backup_if_needed() {
  local dest="$1"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      report INFO "Replacing existing symlink: $dest"
      if (( DRY_RUN )); then
        report INFO "[dry-run] would remove: $dest"
        return 0
      fi
      rm -f "$dest"
      return 0
    fi

    if [[ -f "$dest" ]]; then
      local bak="${dest}.setup-dotfiles.bak"
      if [[ -e "$bak" ]]; then
        report WARN "Backup already exists and would be overwritten: $bak"
        report WARN "Remove it first or back it up manually."
        return 1
      fi
      report INFO "Backing up existing file: $dest -> $bak"
      if (( DRY_RUN )); then
        report INFO "[dry-run] would copy: $dest -> $bak"
        return 0
      fi
      cp -a "$dest" "$bak"
      report OK "backed up: $dest -> $bak"
      return 0
    fi

    if [[ -d "$dest" ]]; then
      report WARN "Destination is a directory (not handled): $dest"
      return 1
    fi
  fi
  return 0
}

################################################################################
# Apply OS-specific patch to a source file before symlinking
################################################################################

apply_patch() {
  local src="$1"
  local patch_bin="$DOTFILES_DIR/$PATCH_SCRIPT"

  if [[ ! -x "$patch_bin" ]]; then
    report FAIL "patch script missing or not executable: $patch_bin"
    return 1
  fi

  if "$patch_bin" "$src"; then
    report OK "patched: $src"
    return 0
  else
    report FAIL "patch failed for: $src"
    return 1
  fi
}

################################################################################
# Symlink one file
################################################################################

install_one() {
  local repo_name="$1"
  local dest_rel="$2"

  local src="$DOTFILES_DIR/$repo_name"
  local dest="$HOME_DIR/$dest_rel"

  if [[ ! -f "$src" ]]; then
    report FAIL "source missing: $src"
    return 1
  fi

  if ! apply_patch "$src"; then
    return 1
  fi

  if ! backup_if_needed "$dest"; then
    return 1
  fi

  if (( DRY_RUN )); then
    report INFO "[dry-run] would symlink: $src -> $dest"
    return 0
  fi

  if ln -sf "$src" "$dest"; then
    report OK "symlinked: $dest_rel -> $src"
  else
    report FAIL "failed to symlink: $src -> $dest"
    return 1
  fi
}

################################################################################
# Main
################################################################################

main() {
  report INFO "dotfiles dir: $DOTFILES_DIR"
  report INFO "detected OS: $OSTYPE_TAG"
  report INFO "home: $HOME_DIR"
  report INFO "using patch script: $PATCH_SCRIPT"

  if (( DRY_RUN )); then
    report INFO "--- dry run ---"
  fi

  check_prereqs || true
  init_submodules

  local failed=0
  local repo_name dest_rel
  for entry in "${INSTALL_MAP[@]}"; do
    repo_name="${entry%%:*}"
    dest_rel="${entry#*:}"
    repo_name="$(echo "$repo_name" | xargs)"
    dest_rel="$(echo "$dest_rel" | xargs)"

    if ! install_one "$repo_name" "$dest_rel"; then
      failed=1
    fi
  done

  if (( DRY_RUN )); then
    report INFO "--- end dry run ---"
  fi

  if (( failed )); then
    report FAIL "some installations failed — review warnings above"
    exit 1
  fi

  report OK "dotfiles installed"

  if [[ "$OSTYPE_TAG" == "arch" ]]; then
    report INFO "Next steps on Arch:"
    report INFO "  - ensure zsh is your login shell: chsh -s \$(command -v zsh)"
    report INFO "  - install missing tools as needed, e.g.: sudo pacman -S zsh git fzf fd eza zoxide bat"
    report INFO "  - if you use nvm: install via pacman (nvm) or manually, then uncomment the NVM loader in .zshrc"
    report INFO "  - if you use oh-my-zsh: curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh (or pacman -S oh-my-zsh)"
    report INFO "  - git credential helper: sudo pacman -S gnome-keyring-libsecret (and ensure gnome-keyring is running)"
  fi
}

main
