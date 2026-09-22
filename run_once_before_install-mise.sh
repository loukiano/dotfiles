#!/bin/bash
# Installs mise for this account into ~/.local/bin (no admin needed).
# "run_once_" = chezmoi runs this once per account and remembers it did.
# "before_"   = it runs before files are written, so mise exists by the time .zshrc uses it.
set -euo pipefail
if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi
