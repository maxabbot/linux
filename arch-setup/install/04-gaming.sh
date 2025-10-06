#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=../../modules/gaming.sh
source "${REPO_ROOT}/modules/gaming.sh"

install_gaming_stack
