#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Gaming stack installation shared across profiles.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

: "${INSTALL_APOLLO:=0}"

_enable_multilib_repo() {
  local pacman_conf=/etc/pacman.conf
  if grep -q '^\[multilib\]' "$pacman_conf"; then
    log_info "multilib repository already enabled"
    return
  fi

  log_info "Enabling multilib repository"
  printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a "$pacman_conf" >/dev/null
  sudo pacman -Sy
}
get_gaming_pacman_packages() {
  _enable_multilib_repo

  local steam_packages=(
    steam
    lib32-mesa
    lib32-vulkan-icd-loader
    lib32-vulkan-intel
    lib32-vulkan-radeon
  )

  local wine_packages=(
    wine-staging
    wine-mono
    wine-gecko
    vkd3d-proton
  )

  local controller_packages=(
    steam-devices
    antimicrox
    joyutils
  )

  local performance_packages=(
    gamemode
    lib32-gamemode
    gamescope
    vkbasalt
    corectrl
    mesa-utils
    vulkan-tools
  )

  local overlay_packages=(
    mangohud
    lib32-mangohud
  )

  local media_packages=(
    obs-studio
  )

  local benchmark_packages=(
    vkmark
    glmark2
    radeontop
  )

  printf '%s\n' \
    "${steam_packages[@]}" \
    "${wine_packages[@]}" \
    "${controller_packages[@]}" \
    "${performance_packages[@]}" \
    "${overlay_packages[@]}" \
    "${media_packages[@]}" \
    "${benchmark_packages[@]}"
}

get_gaming_aur_packages() {
  local aur_packages=(
    protonup-qt
    moonlight-qt
    xpadneo-dkms
    ds4drv
    latencyflex
    goverlay
    heroic-games-launcher-bin
    itch-bin
    legendary
    sunshine-bin
    parsec-bin
    gpu-screen-recorder
    obs-vkcapture
    obs-gstreamer
    dxvk-bin
    protontricks
    winetricks-git
    bottles
    ferret
  )

  if [[ "${INSTALL_APOLLO}" == "1" ]]; then
    aur_packages+=(apollo-bin)
  fi

  printf '%s\n' "${aur_packages[@]}"
}

install_gaming_stack() {
  mapfile -t pacman_packages < <(get_gaming_pacman_packages)
  pacman_install "${pacman_packages[@]}"

  mapfile -t aur_packages < <(get_gaming_aur_packages)
  yay_install "${aur_packages[@]}"

  configure_flatpak
  enable_user_service_now gamemoded.service || true

  log_info "Use Legendary with Lutris or Heroic to manage Epic titles."
  log_info "Launch Steam and enable Proton, then run ProtonUp-Qt for Proton-GE."
  log_info "Moonlight/Sunshine or Parsec are now available for streaming sessions."
  log_success "Gaming stack installed."
}
