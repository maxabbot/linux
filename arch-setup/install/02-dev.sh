#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/../.." >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=../../modules/development.sh
source "${REPO_ROOT}/modules/development.sh"

install_development
