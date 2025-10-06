#!/usr/bin/env bash
# Opinionated profile for the Arch work laptop.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/base.sh
source "${REPO_ROOT}/modules/base.sh"
# shellcheck source=../modules/development.sh
source "${REPO_ROOT}/modules/development.sh"
# shellcheck source=../modules/productivity.sh
source "${REPO_ROOT}/modules/productivity.sh"

# Laptop defaults unless overridden by the environment
export POWER_MANAGEMENT="${POWER_MANAGEMENT:-tlp}"
export ENABLE_DOCKER="${ENABLE_DOCKER:-1}"
export ENABLE_LIBVIRT="${ENABLE_LIBVIRT:-0}"

install_base
install_development
install_productivity

echo
log_success "Work laptop profile complete. Review optional scripts in arch-setup/install for extras."
