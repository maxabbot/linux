#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PACMAN_PACKAGES=(
  steam
  lutris
  heroic-games-launcher
  protontricks
  gamemode
  mangohud
  wine
  wine-gecko
  wine-mono
  sunshine
  obs-studio
  nvidia-utils
  nvidia-settings
  lib32-nvidia-utils
  vulkan-icd-loader
  lib32-vulkan-icd-loader
  nvidia-prime
)

AUR_PACKAGES=(
  parsec-bin
  wlrobs
  envycontrol
)

if [[ "${INSTALL_APOLLO:-0}" == "1" ]]; then
  AUR_PACKAGES+=(apollo-bin)
fi

pacman_install "${PACMAN_PACKAGES[@]}"
yay_install "${AUR_PACKAGES[@]}"

enable_service_now gamemoded.service || true

log_success "Gaming stack and NVIDIA enhancements installed."
