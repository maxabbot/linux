#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

PACMAN_PACKAGES=(
  element-desktop
  vlc
  mpv
  gthumb
  shotwell
  restic
  borg
  timeshift
  syncthing
  btop
  htop
  glances
  nvtop
  poetry
  anki
)

AUR_PACKAGES=(
  zen-browser-bin
  google-chrome
  slack-desktop
  zoom
  mega-cmd-bin
  nvm
  zotero-bin
)

pacman_install "${PACMAN_PACKAGES[@]}"
yay_install "${AUR_PACKAGES[@]}"

log_success "Optional software installed."
