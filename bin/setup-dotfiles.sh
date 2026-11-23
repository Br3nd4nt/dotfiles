#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_NAME="$(basename "$0")"
LOG_FILE=""
SILENT=0

usage() {
  cat <<'USAGEEOF'
Usage: $SCRIPT_NAME [OPTIONS]

Verifies and installs the dotfiles in DOTFILES_DIR.
Reports what is missing or misconfigured and stops before making destructive changes.

Options:
  -h, --help        Show this help and exit
  -q, --quiet       Only print problems; suppress OK lines
  -l, --log FILE    Append a machine-readable report to FILE
USAGEEOF
  exit 0
}
