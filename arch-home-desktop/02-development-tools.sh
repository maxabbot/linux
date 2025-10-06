#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/development.sh
source "${REPO_ROOT}/modules/development.sh"

export ENABLE_DOCKER="${ENABLE_DOCKER:-1}"
export ENABLE_LIBVIRT="${ENABLE_LIBVIRT:-0}"

install_development
