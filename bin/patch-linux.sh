#!/usr/bin/env bash
# patch-linux.sh — patch a dotfile for Linux / Arch.
# Usage: patch-linux.sh <path-to-dotfile>
# Expects: OSTYPE_TAG (arch|linux), HOME exported.
set -euo pipefail

SRC="${1:?missing dotfile path}"
[[ -f "$SRC" ]] || { echo "patch-linux.sh: not a file: $SRC" >&2; exit 1; }

# --- Portable in-place sed helper ---
if sed --version >/dev/null 2>&1; then
  _sed_inplace=(sed -i)
else
  _sed_inplace=(sed -i '')
fi
sed_inplace() {
  "${_sed_inplace[@]}" "$@" || true
}

# --- Minimal reporter (no dependency on setup-dotfiles.sh) ---
report() {
  local status="$1"; shift
  printf '[%s] %s\n' "$status" "$*" >&2
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' RETURN

base="$(basename "$SRC")"

case "$base" in
  gitconfig)
    sed -E \
      -e "s#excludesfile = /Users/[^[:space:]]+#excludesfile = $HOME/.gitignore_global#g" \
      -e "s#excludesfile = /home/[^[:space:]]+#excludesfile = $HOME/.gitignore_global#g" \
      "$SRC" > "$tmp" || true

    if grep -q 'osxkeychain' "$tmp" 2>/dev/null; then
      if [[ "$OSTYPE_TAG" == "arch" ]]; then
        sed_inplace 's#helper = osxkeychain#helper = libsecret#' "$tmp"
        report INFO "gitconfig: osxkeychain -> libsecret (Arch)"
        report INFO "  Install Arch helper with: sudo pacman -S gnome-keyring-libsecret"
      else
        sed_inplace 's#helper = osxkeychain#helper = store#' "$tmp"
        report INFO "gitconfig: osxkeychain -> store (generic Linux)"
      fi
    fi

    cp "$tmp" "$SRC"
    ;;

  zprofile)
    # Drop macOS-only PATH lines. Operate on $SRC in place via sed_inplace
    # (same as zshrc branch) so nothing is silently lost.
    if grep -qE 'export PATH="/opt/local/bin:/opt/local/sbin:\$PATH"' "$SRC" 2>/dev/null; then
      sed_inplace 's#export PATH="/opt/local/bin:/opt/local/sbin:\$PATH"##' "$SRC"
      report INFO "zprofile: removed MacPorts PATH"
    fi
    if grep -qE 'export PATH="/opt/homebrew/bin:\$PATH"' "$SRC" 2>/dev/null; then
      sed_inplace 's#export PATH="/opt/homebrew/bin:\$PATH"##' "$SRC"
      report INFO "zprofile: removed Homebrew PATH"
    fi
    if grep -qE 'export PATH="/opt/homebrew/opt/openjdk@17/bin:\$PATH"' "$SRC" 2>/dev/null; then
      sed_inplace 's#export PATH="/opt/homebrew/opt/openjdk@17/bin:\$PATH"##' "$SRC"
      report INFO "zprofile: removed openjdk@17 PATH"
    fi

    # Drop macOS-only swift PATH (also present in zshrc, handled there).
    if grep -qE 'export PATH="/opt/homebrew/opt/swift/bin:\$PATH"' "$SRC" 2>/dev/null; then
      sed_inplace 's#export PATH="/opt/homebrew/opt/swift/bin:\$PATH"##' "$SRC"
      report INFO "zprofile: removed macOS Swift toolchain PATH"
    fi

    # Drop macOS-only installer blocks.
    if grep -q '# Added by swiftly' "$SRC" 2>/dev/null; then
      sed_inplace '/# Added by swiftly/,/^$/d' "$SRC"
      report INFO "zprofile: removed swiftly block"
    fi
    if grep -q '# Added by OrbStack' "$SRC" 2>/dev/null; then
      sed_inplace '/# Added by OrbStack/,/^$/d' "$SRC"
      report INFO "zprofile: removed OrbStack block"
    fi
    if grep -q '# Added by Antigravity CLI installer' "$SRC" 2>/dev/null; then
      sed_inplace '/# Added by Antigravity CLI installer/,/^$/d' "$SRC"
      report INFO "zprofile: removed Antigravity block"
    fi

    # Append an Arch-friendly block if missing.
    if ! grep -q '# — Arch Linux block (added by setup-dotfiles.sh) —' "$SRC" 2>/dev/null; then
      cat >> "$SRC" <<'ARCHBLOCK'

# — Arch Linux block (added by setup-dotfiles.sh) —
if [[ "$(uname -s)" != "Darwin" ]]; then
  # Common Linux/Arch PATH additions (customize as needed)
  # export PATH="$HOME/.local/bin:$PATH"

  # Java: prefer a version manager (sdkman / pacman) over hardcoding
  # export JAVA_HOME=/usr/lib/jvm/default

  # Python: prefer pyenv / uv / system python from pacman
  # export PYENV_ROOT="$HOME/.pyenv"
  # export PATH="$PYENV_ROOT/bin:$PATH"
fi
ARCHBLOCK
      report INFO "zprofile: appended Arch Linux block"
    fi
    ;;

  zshrc)
    # Remove macOS Homebrew nvm loader, replace with commented Linux loader.
    if grep -q '/opt/homebrew/opt/nvm/nvm.sh' "$SRC" 2>/dev/null; then
      sed -E \
        -e '/^[[:space:]]*export NVM_DIR="\$HOME/\.nvm"$/,/^$/d' \
        -e '/\[ -s "/opt/homebrew/opt/nvm/nvm.sh" \]/d' \
        -e '/\[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" \]/d' \
        "$SRC" > "$tmp" || true
      mv "$tmp" "$SRC"

      if ! grep -q '# — Linux NVM loader (added by setup-dotfiles.sh) —' "$SRC" 2>/dev/null; then
        cat >> "$SRC" <<'NVMBLOCK'

# — Linux NVM loader (added by setup-dotfiles.sh) —
# Uncomment and adjust if NVM is installed via pacman / nodenv / manually.
# export NVM_DIR="$HOME/.nvm"
# [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
# [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
NVMBLOCK
        report INFO "zshrc: replaced Homebrew nvm loader with commented Linux loader"
      fi
    fi

    # Drop Antigravity absolute-path block.
    if grep -q '# Added by Antigravity CLI installer' "$SRC" 2>/dev/null; then
      sed -E \
        -e '/# Added by Antigravity CLI installer$/,/^$/d' \
        "$SRC" > "$tmp" || true
      mv "$tmp" "$SRC"
    fi

    # fzf-git: /usr/local/bin -> /usr/bin
    if grep -q 'source /usr/local/bin/fzf-git' "$SRC" 2>/dev/null; then
      sed_inplace 's#source /usr/local/bin/fzf-git#source /usr/bin/fzf-git#' "$SRC"
      report INFO "zshrc: /usr/local/bin/fzf-git -> /usr/bin/fzf-git"
    fi

    # brew alias -> pacman alias
    if grep -q '^alias bubu="brew update && brew upgrade"' "$SRC" 2>/dev/null; then
      sed_inplace 's#^alias bubu="brew update && brew upgrade"#alias bubu="pacman -Syu"#' "$SRC"
      report INFO "zshrc: brew alias -> pacman alias"
    fi

    # ip(): macOS ifconfig en0 -> Linux curl + ip route
    if grep -q 'ifconfig en0' "$SRC" 2>/dev/null; then
      # Find the ip() function start. This awk treats () as regex grouping,
      # so escape the parens to match literal 'ip()'. Tolerate leading whitespace
      # and any spaces between 'ip()' and the opening brace.
      _ip_start="$(awk '/^[[:space:]]*ip\(\)[[:space:]]*[{]/{print NR; exit}' "$SRC")"
      if [[ -n "$_ip_start" ]]; then
        # Find the matching closing brace (tolerate leading whitespace).
        _ip_end="$(awk -v s="$_ip_start" 'NR>s && /^[[:space:]]*}/{print NR; exit}' "$SRC")"
        if [[ -n "$_ip_end" ]]; then
          {
            head -n "$((_ip_start - 1))" "$SRC"
            echo "ip() {"
            echo "    # global ip"
            echo "    printf \"global: \""
            echo "    curl -s ipv4.icanhazip.com"
            echo "    # local ip"
            echo "    printf \"local: \""
            echo '    local _iface="${1:-$(ip route get 1.1.1.1 2>/dev/null | awk "{print $5}" | head -n1)}"'
            echo '    [[ -n "$_iface" ]] && ip -4 addr show "$_iface" 2>/dev/null | awk "/inet / {print $2}" | cut -d/ -f1 || true'
            echo "    echo"
            echo "}"
            tail -n +"$((_ip_end + 1))" "$SRC"
          } > "$tmp" && mv "$tmp" "$SRC"
          report INFO "zshrc: rewrote ip() for Linux"
        else
          # Closing brace not found; fall back to a sed-range replace.
          sed_inplace '/^[[:space:]]*ip\(\)[[:space:]]*[{]/,/^[[:space:]]*}/c\
ip() {\
    # global ip\
    printf "global: "\
    curl -s ipv4.icanhazip.com\
    # local ip\
    printf "local: "\
    local _iface="${1:-$(ip route get 1.1.1.1 2>/dev/null | awk "{print $5}" | head -n1)}"\
    [[ -n "$_iface" ]] && ip -4 addr show "$_iface" 2>/dev/null | awk "/inet / {print $2}" | cut -d/ -f1 || true\
    echo\
}' "$SRC" || true
          report INFO "zshrc: rewrote ip() for Linux (sed fallback)"
        fi
      else
        # ip() function not found by line scan; use a wider sed fallback keyed
        # on the ifconfig en0 line itself.
        sed_inplace '/ifconfig en0/,/^[[:space:]]*}$/c\
ip() {\
    # global ip\
    printf "global: "\
    curl -s ipv4.icanhazip.com\
    # local ip\
    printf "local: "\
    local _iface="${1:-$(ip route get 1.1.1.1 2>/dev/null | awk "{print $5}" | head -n1)}"\
    [[ -n "$_iface" ]] && ip -4 addr show "$_iface" 2>/dev/null | awk "/inet / {print $2}" | cut -d/ -f1 || true\
    echo\
}' "$SRC" || true
        report INFO "zshrc: rewrote ip() for Linux (sed fallback)"
      fi
    fi

    # macOS Swift toolchain PATH in zshrc -> remove (Arch uses system/other Swift).
    if grep -q 'export PATH="/opt/homebrew/opt/swift/bin:$PATH"' "$SRC" 2>/dev/null; then
      sed_inplace 's#export PATH="/opt/homebrew/opt/swift/bin:$PATH"##' "$SRC"
      report INFO "zshrc: removed macOS Swift toolchain PATH"
    fi

    # macOS-only ls alias flag: -G only works on BSD; prefer --color=auto on Linux.
    if grep -q "alias ls='ls -p -G'" "$SRC" 2>/dev/null; then
      sed_inplace "s#alias ls='ls -p -G'#alias ls='ls -p --color=auto'#" "$SRC"
      report INFO "zshrc: ls alias -G -> --color=auto"
    fi

    ;;

  *)
    # Nothing to patch for other files.
    ;;
esac

# Always normalize stray carriage returns.
sed_inplace 's/\r$//' "$SRC" 2>/dev/null || true
