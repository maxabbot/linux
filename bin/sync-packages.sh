#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

cd "${REPO_ROOT}"

# shellcheck source=modules/base.sh
source modules/base.sh
# shellcheck source=modules/development.sh
source modules/development.sh
# shellcheck source=modules/productivity.sh
source modules/productivity.sh
# shellcheck source=modules/nvidia.sh
source modules/nvidia.sh
# shellcheck source=modules/gaming.sh
source modules/gaming.sh

: "${PACMAN_OUTPUT:=${REPO_ROOT}/arch-setup/packages/pacman-packages.txt}"
: "${AUR_OUTPUT:=${REPO_ROOT}/arch-setup/packages/aur-packages.txt}"
: "${EXTRA_PACMAN_PACKAGES:=}"
: "${EXTRA_AUR_PACKAGES:=}"

collect_packages() {
  local collector_function="$1"
  local -n target_array="$2"

  if declare -F "${collector_function}" >/dev/null 2>&1; then
    mapfile -t packages < <("${collector_function}")
    if ((${#packages[@]})); then
      target_array+=("${packages[@]}")
    fi
  fi
}

pacman_packages=()
aur_packages=()

collect_packages get_base_pacman_packages pacman_packages
collect_packages get_development_pacman_packages pacman_packages
collect_packages get_productivity_pacman_packages pacman_packages
collect_packages get_nvidia_pacman_packages pacman_packages
collect_packages get_gaming_pacman_packages pacman_packages

collect_packages get_development_aur_packages aur_packages
collect_packages get_productivity_aur_packages aur_packages
collect_packages get_gaming_aur_packages aur_packages

if [[ -n "${EXTRA_PACMAN_PACKAGES}" ]]; then
  read -r -a extra_pacman <<<"${EXTRA_PACMAN_PACKAGES}"
  pacman_packages+=("${extra_pacman[@]}")
fi

if [[ -n "${EXTRA_AUR_PACKAGES}" ]]; then
  read -r -a extra_aur <<<"${EXTRA_AUR_PACKAGES}"
  aur_packages+=("${extra_aur[@]}")
fi

write_manifest() {
  local path="$1"
  shift
  printf '%s\n' "$@" >"${path}"
}

unique_pacman=$(printf '%s\n' "${pacman_packages[@]}" | sort -u)
unique_aur=$(printf '%s\n' "${aur_packages[@]}" | sort -u)

duplicate_count() {
  local total="$1"
  local unique="$2"
  awk -v t="${total}" -v u="${unique}" 'BEGIN { print t - u }'
}

pacman_total=${#pacman_packages[@]}
pacman_unique_count=$(printf '%s\n' "${pacman_packages[@]}" | sort -u | wc -l | tr -d ' ')
aur_total=${#aur_packages[@]}
aur_unique_count=$(printf '%s\n' "${aur_packages[@]}" | sort -u | wc -l | tr -d ' ')

pacman_duplicates=$(duplicate_count "${pacman_total}" "${pacman_unique_count}")
aur_duplicates=$(duplicate_count "${aur_total}" "${aur_unique_count}")

conflicts=()
if printf '%s\n' "${unique_pacman}" | grep -qx 'code'; then
  conflicts+=('Remove repo code in favour of visual-studio-code-bin')
fi
if printf '%s\n' "${unique_pacman}" | grep -qx 'rust'; then
  conflicts+=('Remove repo rust in favour of rustup')
fi
if printf '%s\n' "${unique_aur}" | grep -qx 'spotify'; then
  conflicts+=('Drop spotify in favour of spotify-launcher')
fi

write_manifest "${PACMAN_OUTPUT}" ${unique_pacman}
write_manifest "${AUR_OUTPUT}" ${unique_aur}

echo "Wrote $(wc -l <"${PACMAN_OUTPUT}") pacman entries to ${PACMAN_OUTPUT}"
echo "Wrote $(wc -l <"${AUR_OUTPUT}") AUR entries to ${AUR_OUTPUT}"

echo "Duplicate pacman entries purged: ${pacman_duplicates}"
echo "Duplicate AUR entries purged: ${aur_duplicates}"

if ((${#conflicts[@]})); then
  echo "Conflicts detected:"
  for conflict in "${conflicts[@]}"; do
    echo "  - ${conflict}"
  done
else
  echo "No conflicts detected."
fi
