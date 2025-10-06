#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/base.sh
source "${REPO_ROOT}/modules/base.sh"

export POWER_MANAGEMENT="${POWER_MANAGEMENT:-tlp}"
export ENABLE_GUFW="${ENABLE_GUFW:-1}"

install_base
