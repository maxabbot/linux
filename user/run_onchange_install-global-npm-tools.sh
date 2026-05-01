#!/bin/bash
# Install global npm tools via mise-managed node.
# chezmoi re-runs this when the file content changes — bump the hash to upgrade.
# hash: 2

set -euo pipefail

# Activate mise to get its node/npm in PATH
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
  mise install node 2>/dev/null || true
else
  echo "mise not found — install it first (AUR: mise-bin)"
  exit 1
fi

if ! command -v npm &>/dev/null; then
  echo "npm not available after mise activation"
  exit 1
fi

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Done. Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
