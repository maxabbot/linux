#!/usr/bin/env bash
# Shared helper functions for Arch setup scripts.

log_info() {
  printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

log_warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*"
}

log_success() {
  printf '\033[1;32m[SUCCESS]\033[0m %s\n' "$*"
}

update_system() {
  log_info "Updating system packages"
  sudo pacman -Syu --noconfirm
}

pacman_install() {
  if [ $# -eq 0 ]; then
    return
  fi

  log_info "Installing with pacman: $*"
  sudo pacman -S --noconfirm --needed "$@"
}

yay_install() {
  if [ $# -eq 0 ]; then
    return
  fi

  if ! command -v yay >/dev/null 2>&1; then
    log_warn "Skipping AUR packages (yay not found): $*"
    return
  fi

  log_info "Installing with yay: $*"
  yay -S --noconfirm --needed "$@"
}

enable_service_now() {
  local unit="$1"
  if systemctl is-enabled "$unit" >/dev/null 2>&1; then
    log_info "Service already enabled: $unit"
  else
    log_info "Enabling service: $unit"
    sudo systemctl enable --now "$unit"
  fi
}

detect_microcode_package() {
  if grep -q "AuthenticAMD" /proc/cpuinfo; then
    printf 'amd-ucode'
  else
    printf 'intel-ucode'
  fi
}
