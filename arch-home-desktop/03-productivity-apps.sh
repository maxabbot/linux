#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

# shellcheck source=../modules/productivity.sh
source "${REPO_ROOT}/modules/productivity.sh"

install_productivity
