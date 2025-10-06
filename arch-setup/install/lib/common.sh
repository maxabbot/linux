#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Compatibility shim to the shared modules helpers.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/../../.." >/dev/null 2>&1 && pwd)

# shellcheck source=../../../modules/lib/common.sh
source "${REPO_ROOT}/modules/lib/common.sh"

detect_microcode_package() {
  if grep -q "AuthenticAMD" /proc/cpuinfo; then
    printf 'amd-ucode'
  else
    printf 'intel-ucode'
  fi
}
