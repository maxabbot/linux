#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

ENABLE_DOCKER=${ENABLE_DOCKER:-0}
ENABLE_LIBVIRT=${ENABLE_LIBVIRT:-0}

DEVELOPMENT_PACKAGES=(
  base-devel
  git
  gnupg
  ripgrep
  fd
  bat
  helix
  neovim
  code
  alacritty
  kitty
  direnv
  python-pip
  nodejs
  npm
  go
  rustup
  podman
  podman-compose
  docker
  docker-compose
  qemu-desktop
  virt-manager
)

pacman_install "${DEVELOPMENT_PACKAGES[@]}"

if [[ "${ENABLE_DOCKER}" == "1" ]]; then
  enable_service_now docker.service
  log_info "Consider adding your user to the docker group: sudo usermod -aG docker $USER"
else
  log_warn "Docker service not enabled (set ENABLE_DOCKER=1 to auto-enable)."
fi

if [[ "${ENABLE_LIBVIRT}" == "1" ]]; then
  enable_service_now libvirtd.service
  log_info "Add user to libvirt groups: sudo usermod -aG libvirt $USER"
else
  log_warn "libvirtd service not enabled (set ENABLE_LIBVIRT=1 to auto-enable)."
fi

log_success "Development tooling installed."
