#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
ROOT_DIR=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)
TARGET="${ROOT_DIR}/arch-work-laptop/03-productivity-apps.sh"

if [[ ! -f "${TARGET}" ]]; then
  echo "Missing shared setup script: ${TARGET}" >&2
  exit 1
fi

exec bash "${TARGET}" "$@"
