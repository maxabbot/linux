#!/bin/bash
# Gaming setup with Steam, Proton, and related tools
# Includes Apollo streaming and other gaming utilities

set -e

echo "=========================================="
echo "Installing Gaming Software"
echo "=========================================="

# Enable multilib repository (needed for 32-bit games)
echo "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy
fi

# Install Steam with Proton support
echo "Installing Steam..."
sudo pacman -S --noconfirm --needed \
    steam \
    lib32-mesa \
    lib32-vulkan-icd-loader \
    lib32-vulkan-intel \
    lib32-vulkan-radeon

# Install Wine and Proton-related tools
echo "Installing Wine and Proton tools..."
sudo pacman -S --noconfirm --needed \
    wine-staging \
    wine-mono \
    wine-gecko

# Install ProtonUp-Qt for easy Proton-GE management
echo "Installing ProtonUp-Qt..."
yay -S --noconfirm --needed \
    protonup-qt
#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/gaming.sh
source "${REPO_ROOT}/modules/gaming.sh"

install_gaming_stack

