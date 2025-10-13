#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Shared helper functions for linux-setup-scripts modules.

log_info() {
  printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

log_warn() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*"
}

log_success() {
  printf '\033[1;32m[SUCCESS]\033[0m %s\n' "$*"
}

is_truthy() {
  local value="${1:-}"
  case "${value,,}" in
    1|true|yes|on) return 0 ;;
    *) return 1 ;;
  esac
}

flag_enabled() {
  local var_name="$1"
  local default_value="${2:-0}"
  local value

  value=$(printenv "$var_name" 2>/dev/null || true)
  value=${value%$'\n'}

  local indirect_value="${!var_name-}"

  if [[ -z "$value" && -n "$indirect_value" ]]; then
    value="$indirect_value"
  fi

  if [[ -z "$value" ]]; then
    value="$default_value"
  fi

  is_truthy "$value"
}

update_system() {
  log_info "Updating system packages"
  sudo pacman -Syu --noconfirm
}

pacman_install() {
  if [[ $# -eq 0 ]]; then
    return
  fi

  log_info "Installing with pacman: $*"
  sudo pacman -S --noconfirm --needed "$@"
}

ensure_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  log_info "Installing yay AUR helper"
  local tmpdir
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  if ! pushd "$tmpdir/yay" >/dev/null; then
    rm -rf "$tmpdir"
    return 1
  fi
  makepkg -si --noconfirm
  popd >/dev/null || return 1
  rm -rf "$tmpdir"
}

yay_install() {
  if [[ $# -eq 0 ]]; then
    return
  fi

  if ! command -v yay >/dev/null 2>&1; then
    ensure_yay
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

enable_user_service_now() {
  local unit="$1"
  if systemctl --user is-enabled "$unit" >/dev/null 2>&1; then
    log_info "User service already enabled: $unit"
  else
    log_info "Enabling user service: $unit"
    systemctl --user enable --now "$unit"
  fi
}

pip_install_user() {
  if [[ $# -eq 0 ]]; then
    return
  fi

  if ! command -v pip >/dev/null 2>&1; then
    log_warn "pip not available; skipping Python package install for: $*"
    return
  fi

  # Handle externally-managed Python environments by using --break-system-packages
  # This is needed for PEP 668 compliance in modern Python installations
  log_info "Installing Python packages with pip --user: $*"
  
  # Try with custom cache dir to avoid disk quota issues
  local pip_cache_dir="${HOME}/.cache/pip"
  mkdir -p "$pip_cache_dir"
  
  if ! pip install --user --break-system-packages --cache-dir "$pip_cache_dir" "$@"; then
    log_warn "pip install failed, trying with --no-cache-dir"
    pip install --user --break-system-packages --no-cache-dir "$@"
  fi
}

append_kernel_param_once() {
  local param="$1"
  local grub_file=/etc/default/grub

  if [[ ! -f "$grub_file" ]]; then
    log_warn "GRUB config not found at $grub_file"
    return 1
  fi

  if grep -q "$param" "$grub_file"; then
    log_info "Kernel parameter already present: $param"
    return 0
  fi

  log_info "Appending kernel parameter: $param"
  sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$param /" "$grub_file"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

write_file_if_changed() {
  local target="$1"
  local tmp
  tmp=$(mktemp)
  cat >"$tmp"

  if [[ -f "$target" ]] && cmp -s "$tmp" "$target"; then
    log_info "No changes for $target"
    rm -f "$tmp"
    return
  fi

  log_info "Updating $target"
  sudo install -Dm644 "$tmp" "$target"
  rm -f "$tmp"
}

run_as_root_once() {
  local description="$1"
  local command="$2"

  if [[ $EUID -ne 0 ]]; then
    log_warn "Skipping root-only task '$description' (not running as root)."
    return
  fi

  eval "$command"
}

configure_flatpak() {
  if ! command -v flatpak >/dev/null 2>&1; then
    pacman_install flatpak
  fi

  if ! command -v flatpak >/dev/null 2>&1; then
    log_warn "flatpak command still unavailable after install attempt."
    return 1
  fi

  if ! flatpak remote-list --system | grep -q flathub; then
    log_info "Adding Flathub remote"
    sudo flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
}

flatpak_install_app() {
  local app="$1"
  if [[ -z "$app" ]]; then
    return
  fi

  if ! configure_flatpak; then
    log_warn "Skipping Flatpak install for $app (Flatpak unavailable)."
    return
  fi

  if flatpak list --system | awk '{print $1}' | grep -Fxq "$app"; then
    log_info "Flatpak app already installed: $app"
    return
  fi

  log_info "Installing Flatpak app: $app"
  sudo flatpak install --system -y flathub "$app"
}
