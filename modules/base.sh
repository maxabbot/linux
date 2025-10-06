#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Base system installation shared across profiles.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

: "${POWER_MANAGEMENT:=tlp}"
: "${ENABLE_GUFW:=1}"

_detect_microcode_package() {
  if grep -q "AuthenticAMD" /proc/cpuinfo; then
    printf 'amd-ucode'
  else
    printf 'intel-ucode'
  fi
}

get_base_pacman_packages() {
  local power_management_option="${POWER_MANAGEMENT}"
  local enable_gufw_option="${ENABLE_GUFW}"

  local base_packages=(
    base-devel
    findutils
    coreutils
    grep
    sed
    jq
    bc
    wget
    curl
    git
    gnupg
    vim
    nano
    tmux
    unzip
    zip
    p7zip
    tar
    rsync
    openssh
    man-db
    man-pages
    bash-completion
    reflector
    wireguard-tools
    openvpn
    traceroute
    inetutils
    bind-tools
    ntfs-3g
    xdg-utils
    xdg-user-dirs
    gvfs
    gvfs-smb
    rar
    unrar
    btrfs-progs
    snapper
    exfatprogs
    dosfstools
    lvm2
    parted
    gparted
    cups
    system-config-printer
    networkmanager
    network-manager-applet
    systemd-timesyncd
    ufw
    bluez
    bluez-utils
    blueman
    acpi
    sof-firmware
    lm_sensors
    openrgb
    grim
    libnotify
    swaync
    qt5-wayland
    qt6-wayland
    xorg-xinput
    xclip
    wl-clipboard
    mesa-utils
    vulkan-tools
    stow
    fzf
    ripgrep
    bat
    eza
    shellcheck
    opensc
    pcsclite
    keychain
    htop
    btop
    neofetch
  )

  base_packages+=("$(_detect_microcode_package)")

  case "${power_management_option}" in
    tlp)
      base_packages+=(tlp)
      ;;
    power-profiles-daemon)
      base_packages+=(power-profiles-daemon)
      ;;
    *)
      log_warn "Unknown power management option '${power_management_option}'. Defaulting to power-profiles-daemon."
      power_management_option="power-profiles-daemon"
      base_packages+=(power-profiles-daemon)
      ;;
  esac

  POWER_MANAGEMENT="${power_management_option}"

  if [[ "${enable_gufw_option}" == "1" ]]; then
    base_packages+=(gufw)
  fi

  printf '%s\n' "${base_packages[@]}"
}

install_base() {
  update_system

  mapfile -t base_packages < <(get_base_pacman_packages)
  pacman_install "${base_packages[@]}"
  ensure_yay

  enable_service_now NetworkManager.service
  enable_service_now bluetooth.service
  enable_service_now systemd-timesyncd.service
  enable_service_now cups.service || true
  enable_service_now ufw.service || true

  local power_management="${POWER_MANAGEMENT}"

  case "${power_management}" in
    tlp)
      enable_service_now tlp.service
      ;;
    power-profiles-daemon)
      enable_service_now power-profiles-daemon.service
      ;;
    *)
      log_warn "Unknown power management option '${power_management}', enabling power-profiles-daemon."
      POWER_MANAGEMENT="power-profiles-daemon"
      enable_service_now power-profiles-daemon.service
      ;;
  esac

  log_success "Base system packages installed."
}
