#!/usr/bin/env bash
# patch-macos.sh — macOS dotfiles are left as-is; only normalize line endings.
# Usage: patch-macos.sh <path-to-dotfile>
set -euo pipefail

SRC="${1:?missing dotfile path}"
[[ -f "$SRC" ]] || { echo "patch-macos.sh: not a file: $SRC" >&2; exit 1; }

# Portable in-place sed: GNU sed uses -i, BSD sed uses -i ''.
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)
else
  SED_INPLACE=(sed -i '')
fi

base="$(basename "$SRC")"

# macOS dotfiles are intentionally left untouched.
report INFO "macOS: leaving $SRC as-is"

# Only normalize stray carriage returns.
"${SED_INPLACE[@]}" 's/\r$//' "$SRC" 2>/dev/null || true
