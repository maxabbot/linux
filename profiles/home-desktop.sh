#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Opinionated profile for the Arch home desktop (RTX 40-series, gaming focus).

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/base.sh
source "${REPO_ROOT}/modules/base.sh"
# shellcheck source=../modules/development.sh
source "${REPO_ROOT}/modules/development.sh"
# shellcheck source=../modules/productivity.sh
source "${REPO_ROOT}/modules/productivity.sh"
# shellcheck source=../modules/nvidia.sh
source "${REPO_ROOT}/modules/nvidia.sh"
# shellcheck source=../modules/gaming.sh
source "${REPO_ROOT}/modules/gaming.sh"

# Desktop defaults unless overridden externally
export POWER_MANAGEMENT="${POWER_MANAGEMENT:-power-profiles-daemon}"
export ENABLE_DOCKER="${ENABLE_DOCKER:-1}"
export ENABLE_LIBVIRT="${ENABLE_LIBVIRT:-0}"
export INSTALL_APOLLO="${INSTALL_APOLLO:-0}"

install_base
install_development
install_productivity
install_nvidia_stack
install_gaming_stack

echo
log_success "Home desktop profile complete. Reboot to load the NVIDIA kernel modules."
