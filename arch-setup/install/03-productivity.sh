#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PACMAN_PACKAGES=(
  hyprland
  rofi
  discord
  calibre
  wl-clipboard
  xdg-desktop-portal-hyprland
  polkit-gnome
  pavucontrol
  helvum
  slurp
  thunar
  tmux
  bitwarden
  keepassxc
  firefox
  papirus-icon-theme
  qt5ct
  qt6ct
  kvantum
  kvantum-qt5
  kvantum-qt6
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  noto-fonts-emoji
  ttf-firacode-nerd
)

AUR_PACKAGES=(
  waybar-hyprland-git
  swww
  mpvpaper
  spotify
  cliphist
  grimblast-git
  obsidian
  logseq-desktop-bin
  brave-bin
  zen-browser-bin
  ttf-nerd-fonts-symbols
)

pacman_install "${PACMAN_PACKAGES[@]}"
yay_install "${AUR_PACKAGES[@]}"

log_success "Productivity and desktop applications installed."
