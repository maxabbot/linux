#!/bin/bash
# chezmoi run_onchange script — sets default shell to zsh
# antidote is installed via the AUR package; plugins are managed via ~/.zsh_plugins.txt

set -euo pipefail

if [[ "$SHELL" != */zsh ]]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)" || echo "Could not change shell automatically. Run: chsh -s $(which zsh)"
fi

echo "Shell setup complete!"
