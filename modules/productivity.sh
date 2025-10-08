#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Productivity and desktop tooling shared across profiles.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

: "${ENABLE_SYNC_CLIENTS:=1}"
: "${ENABLE_CREATIVE_SUITE:=1}"
: "${ENABLE_STREAMING_TOOLS:=1}"
: "${ENABLE_SECONDARY_BROWSERS:=1}"

get_productivity_pacman_packages() {
  local desktop_packages=(
    hyprland
    rofi
    xdg-desktop-portal-hyprland
    polkit-gnome
    pavucontrol
    helvum
    slurp
    papirus-icon-theme
    qt5ct
    qt6ct
    kvantum
    kvantum-qt5
    kvantum-qt6
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji
    ttf-firacode-nerd
  )

  local office_packages=(
    libreoffice-fresh
    libreoffice-fresh-en-us
    zathura
    zathura-pdf-mupdf
    okular
    pdfarranger
    ghostscript
  )

  local browser_packages=(
    firefox
  )

  local communication_packages=(
    thunderbird
    remmina
    mattermost-desktop
    element-desktop
  )

  local file_cloud_packages=(
    thunar
    dolphin
    ark
    rclone
  )

  local sync_clients=(
    syncthing
    nextcloud-client
  )

  local creative_packages=(
    gimp
    inkscape
    imagemagick
    krita
    kdenlive
  )

  local capture_packages=(
    flameshot
  )

  local password_packages=(
    keepassxc
    bitwarden
  )

  local note_packages=(
    zim
    xournalpp
  )

  local media_packages=(
    vlc
    mpv
    jellyfin
    calibre
  )

  local monitoring_packages=(
    iotop
    nethogs
  )

  local security_packages=(
    veracrypt
    gnome-keyring
    kwalletmanager
  )

  local helper_packages=(
    timeshift
    redshift
    gammastep
    plasma-systemmonitor
    copyq
  )

  local packages=(
    "${desktop_packages[@]}"
    "${office_packages[@]}"
    "${browser_packages[@]}"
    "${communication_packages[@]}"
    "${file_cloud_packages[@]}"
    "${capture_packages[@]}"
    "${password_packages[@]}"
    "${note_packages[@]}"
    "${media_packages[@]}"
    "${monitoring_packages[@]}"
    "${security_packages[@]}"
    "${helper_packages[@]}"
  )

  if [[ "${ENABLE_SYNC_CLIENTS}" == "1" ]]; then
    packages+=("${sync_clients[@]}")
  fi

  if [[ "${ENABLE_CREATIVE_SUITE}" == "1" ]]; then
    packages+=("${creative_packages[@]}")
  fi

  printf '%s\n' "${packages[@]}"
}

get_productivity_aur_packages() {
  local core_apps=(
    onlyoffice-bin
    masterpdfeditor-free
    google-chrome
    slack-desktop
    discord
    zoom
    obsidian
    joplin-appimage
    standardnotes
    waybar-hyprland-git
    swww
    mpvpaper
    cliphist
    grimblast-git
    logseq-desktop-bin
    brave-bin
    zen-browser-bin
    ttf-nerd-fonts-symbols
    spotify-launcher
    plex-media-server
  )

  local optional_sync=(
    dropbox
    google-drive-ocamlfuse
  )

  local streaming_apps=(
    shotcut
    anydesk-bin
    rustdesk-bin
    stremio
    smarttube-stable-bin
  )

  local packages=("${core_apps[@]}")

  if [[ "${ENABLE_SYNC_CLIENTS}" == "1" ]]; then
    packages+=("${optional_sync[@]}")
  fi

  if [[ "${ENABLE_STREAMING_TOOLS}" == "1" ]]; then
    packages+=("${streaming_apps[@]}")
  fi

  local filtered=()
  for pkg in "${packages[@]}"; do
    if [[ "${ENABLE_SECONDARY_BROWSERS}" != "1" ]] && [[ "$pkg" =~ ^(brave-bin|zen-browser-bin)$ ]]; then
      continue
    fi
    filtered+=("$pkg")
  done

  if ((${#filtered[@]})); then
    printf '%s\n' "${filtered[@]}"
  fi
}

get_productivity_flatpak_apps() {
  printf '%s\n' "com.microsoft.Teams"
}

install_productivity() {
  mapfile -t pacman_packages < <(get_productivity_pacman_packages)
  pacman_install "${pacman_packages[@]}"

  mapfile -t aur_packages < <(get_productivity_aur_packages)
  yay_install "${aur_packages[@]}"

  mapfile -t flatpak_apps < <(get_productivity_flatpak_apps)
  for app in "${flatpak_apps[@]}"; do
    flatpak_install_app "$app"
  done

  log_success "Productivity applications installed."
}
