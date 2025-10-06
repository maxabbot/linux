#!/usr/bin/env bash
# NVIDIA driver stack configuration.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

: "${ENABLE_CUDA_STACK:=1}"

get_nvidia_pacman_packages() {
  local base_packages=(
    nvidia
    nvidia-utils
    nvidia-settings
    lib32-nvidia-utils
    nvidia-prime
    egl-wayland
    vulkan-icd-loader
    lib32-vulkan-icd-loader
    vulkan-tools
    vulkan-validation-layers
    opencl-nvidia
    lib32-opencl-nvidia
    clinfo
    nv-codec-headers
    ffmpeg
    nvtop
    dkms
    linux-lts
    nvidia-lts
  )

  local cuda_packages=(
    cuda
    cudnn
    cuda-tools
  )

  local packages=("${base_packages[@]}")

  if [[ "${ENABLE_CUDA_STACK}" == "1" ]]; then
    packages+=("${cuda_packages[@]}")
  fi

  printf '%s\n' "${packages[@]}"
}

_install_prime_helper() {
  local helper_path=/usr/local/bin/nvidia-prime-run
  local content="#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo \"Usage: nvidia-prime-run <command>\"
  exit 1
fi
__NV_PRIME_RENDER_OFFLOAD=1 \\
__GLX_VENDOR_LIBRARY_NAME=nvidia \\
__VK_LAYER_NV_optimus=NVIDIA_only \\
prime-run \"$@\"
"
  write_file_if_changed "$helper_path" <<<"${content}"
  sudo chmod +x "$helper_path"
}

_configure_coolbits() {
  local config_path=/etc/X11/xorg.conf.d/20-nvidia.conf
  local content="Section \"Device\"
    Identifier \"NVIDIA GPU\"
    Driver \"nvidia\"
    Option \"Coolbits\" \"28\"
EndSection
"
  write_file_if_changed "$config_path" <<<"${content}"
}

_configure_mkinitcpio_modules() {
  local modules_line='MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)'
  local mkinitcpio=/etc/mkinitcpio.conf

  if grep -q 'nvidia_drm' "$mkinitcpio"; then
    log_info "mkinitcpio already configured for NVIDIA modules"
    return
  fi

  log_info "Adding NVIDIA modules to mkinitcpio"
  if grep -q '^MODULES=()' "$mkinitcpio"; then
    sudo sed -i "s/^MODULES=()/${modules_line}/" "$mkinitcpio"
  elif grep -q '^MODULES=(' "$mkinitcpio"; then
    sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' "$mkinitcpio"
  else
    echo "$modules_line" | sudo tee -a "$mkinitcpio" >/dev/null
  fi
  sudo mkinitcpio -P
}

install_nvidia_stack() {
  mapfile -t pacman_packages < <(get_nvidia_pacman_packages)
  pacman_install "${pacman_packages[@]}"

  append_kernel_param_once "nvidia-drm.modeset=1"
  _configure_mkinitcpio_modules
  _configure_coolbits
  _install_prime_helper

  enable_service_now nvidia-persistenced.service

  if systemctl list-unit-files | grep -q 'nvidia-powerd.service'; then
    enable_service_now nvidia-powerd.service
  else
    log_warn "nvidia-powerd.service not available; skipping enable step."
  fi

  log_info "To use the LTS kernel, update your bootloader entries accordingly."
  log_success "NVIDIA stack configured. Please reboot to apply kernel changes."
}
