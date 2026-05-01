#!/bin/bash
# Install global npm tools via nvm.
# chezmoi re-runs this when the file content changes — bump the hash below to upgrade.
# hash: 1

set -euo pipefail

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

if ! command -v npm &>/dev/null; then
  echo "npm not available — run: nvm install --lts"
  exit 1
fi

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Done. Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
