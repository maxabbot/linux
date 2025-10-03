#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

POWER_MANAGEMENT=${POWER_MANAGEMENT:-power-profiles-daemon}
ENABLE_GUFW=${ENABLE_GUFW:-1}

MICROCODE_PKG=$(detect_microcode_package)

BASE_PACKAGES=(
  findutils
  coreutils
  grep
  sed
  jq
  bc
  grim
  libnotify
  swaync
  lm_sensors
  openrgb
  qt5-wayland
  qt6-wayland
  networkmanager
  network-manager-applet
  bluez
  bluez-utils
  blueman
  "${MICROCODE_PKG}"
  systemd-timesyncd
  ufw
  reflector
  btrfs-progs
  snapper
  cups
  system-config-printer
)

case "${POWER_MANAGEMENT}" in
  tlp)
    BASE_PACKAGES+=(tlp)
    POWER_SERVICE="tlp.service"
    ;;
  power-profiles-daemon)
    BASE_PACKAGES+=(power-profiles-daemon)
    POWER_SERVICE="power-profiles-daemon.service"
    ;;
  *)
    log_warn "Unknown power management option '${POWER_MANAGEMENT}'. Skipping power management install."
    POWER_SERVICE=""
    ;;
 esac

if [[ "${ENABLE_GUFW}" == "1" ]]; then
  BASE_PACKAGES+=(gufw)
fi

update_system
pacman_install "${BASE_PACKAGES[@]}"

enable_service_now NetworkManager.service
enable_service_now bluetooth.service
enable_service_now systemd-timesyncd.service
enable_service_now cups.service
enable_service_now ufw.service || true

if [[ -n "${POWER_SERVICE}" ]]; then
  enable_service_now "${POWER_SERVICE}"
fi

log_success "Base system packages installed."
