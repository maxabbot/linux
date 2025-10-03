#!/usr/bin/env bash
set -euo pipefail

AUR_HELPER=${AUR_HELPER:-yay}

if command -v "${AUR_HELPER}" >/dev/null 2>&1; then
  echo "${AUR_HELPER} already installed."
  exit 0
fi

echo "Installing prerequisites for ${AUR_HELPER}"
sudo pacman -S --noconfirm --needed git base-devel

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

case "${AUR_HELPER}" in
  yay)
    git clone https://aur.archlinux.org/yay.git "$WORKDIR/yay"
    (cd "$WORKDIR/yay" && makepkg -si --noconfirm)
    ;;
  paru)
    git clone https://aur.archlinux.org/paru.git "$WORKDIR/paru"
    (cd "$WORKDIR/paru" && makepkg -si --noconfirm)
    ;;
  *)
    echo "Unsupported AUR helper '${AUR_HELPER}'." >&2
    exit 1
    ;;
 esac

echo "${AUR_HELPER} installation complete."
