# Ansible-Installed Packages Documentation

**Generated:** February 22, 2026

This document lists all packages installed by the Ansible configuration management system across different roles and playbooks.

---

## Table of Contents

1. [Base Role](#base-role)
2. [Development Role](#development-role)
3. [Productivity Role](#productivity-role)
4. [Gaming Role](#gaming-role)
5. [NVIDIA Role](#nvidia-role)
6. [Package Summary](#package-summary)

---

## Base Role

**Location:** `system/roles/base/`

The base role installs core system packages required for all configurations.

### Core System Packages (11)
- base-devel
- findutils
- coreutils
- sed
- tar
- bc
- curl
- wget
- rsync
- openssh
- gnupg

### Documentation & Completion (3)
- man-db
- man-pages
- bash-completion

### Networking Packages (11)
- networkmanager
- network-manager-applet
- bluez
- bluez-utils
- blueman
- inetutils
- bind-tools
- traceroute
- nethogs
- iotop
- wireguard-tools

### VPN (1)
- openvpn

### Filesystem Tools (9)
- dosfstools
- exfatprogs
- btrfs-progs
- p7zip
- unzip
- unrar
- zip
- gparted
- parted

### Snapper (1)
- snapper

### Wayland / Display Support (9)
- qt5-wayland
- qt6-wayland
- qt5ct
- qt6ct
- egl-wayland
- xdg-user-dirs
- xdg-utils
- wl-clipboard
- xclip

### CLI Tools & Utilities (17)
- git
- git-lfs
- bat
- eza
- fd
- fzf
- ripgrep
- jq
- tree
- nano
- zsh
- tmux
- fastfetch
- stow
- htop
- btop
- keychain

### Mirror Management (1)
- reflector

### Fonts (4)
- ttf-firacode-nerd
- ttf-jetbrains-mono
- ttf-jetbrains-mono-nerd
- noto-fonts-emoji

### Desktop Services (7)
- cups
- system-config-printer
- pcsclite
- opensc
- gnome-keyring
- polkit-gnome
- libnotify

### Security & Monitoring (3)
- ufw
- lm_sensors
- sof-firmware

### Kernel & System (2)
- linux-lts
- dkms

### Power Management (Dynamic - 1 or 2 packages)
**Options:**
- `power-profiles-daemon`: 1 package
- `tlp`: 2 packages (tlp, tlp-rdw)

### Firewall GUI (Optional)
- gufw (if `enable_gufw: true`)

### Microcode (Conditional - 1 package)
- AMD systems: amd-ucode
- Intel systems: intel-ucode

---

## Development Role

**Location:** `system/roles/development/`

The development role installs programming tools, runtimes, databases, and development utilities.

### Language Runtimes & Compilers (8)
- python
- python-pip
- python-virtualenv
- nodejs
- npm
- go
- rustup
- jdk-openjdk

### Build Tools (4)
- gcc
- clang
- cmake
- make

### Development Utilities (9)
- neovim
- kitty
- direnv
- starship
- zsh
- helix
- shellcheck
- tig
- imagemagick

### Container Tools (2)
- podman
- podman-compose

### Docker (Optional - 2 packages, if `enable_docker: true`)
- docker
- docker-compose

### Database Servers (Optional - 4 packages, if `enable_database_servers: true`)
- postgresql
- mariadb
- redis
- sqlite

### Database CLI Clients (Optional - 1 package, if `enable_gui_db_clients: true`)
- pgcli

### Virtualization (Optional - 4 packages, if `enable_libvirt: true`)
- libvirt
- qemu-full
- virt-manager
- dnsmasq

### Cloud & Infrastructure Tools (7)
- kubectl
- kubectx
- helm
- terraform
- opentofu
- ansible
- jupyter-notebook

### API Tools (2)
- httpie
- jq

### Python Data Science Packages (pip, installed --user)
- python-matplotlib
- python-numpy
- python-pandas
- python-scipy
- python-scikit-learn

### AUR Packages (Always Installed - 7)
- visual-studio-code-bin
- nvm
- sdkman-cli
- insomnia-bin
- postman-bin
- wiremock-standalone
- oh-my-zsh-git

### AUR Cloud & Infrastructure Tools (7)
- kind
- minikube
- aws-cli-v2
- azure-cli
- google-cloud-sdk
- doctl

### AUR Database Tools (Optional - 1 package, if `enable_database_servers: true`)
- mongodb-bin

### AUR Database GUI Clients (Optional - 3 packages, if `enable_gui_db_clients: true`)
- dbeaver
- mycli
- litecli

### AUR Data Platform Tools (Optional - 5 packages, if `enable_data_platforms: true`)
- apache-airflow
- apache-spark
- duckdb-bin
- rapidsai
- ferret

---

## Productivity Role

**Location:** `system/roles/productivity/`

The productivity role installs desktop environment, office applications, browsers, and productivity tools.

### Desktop / Wayland Compositor (9)
- hyprland
- rofi
- waybar
- xdg-desktop-portal-hyprland
- swaync
- gammastep
- copyq
- grim
- slurp

### Office & Documents (7)
- libreoffice-fresh
- xournalpp
- zathura
- zathura-pdf-mupdf
- calibre
- okular
- pdfarranger

### Browsers (1 - AUR only)
- Installed via AUR: google-chrome

### Communication (3)
- thunderbird
- element-desktop

### File Managers (3)
- thunar
- dolphin
- ark

### Cloud & Sync (3)
- nextcloud-client
- syncthing
- rclone

### Creative Suite (Optional - 4 packages, if `enable_creative_suite: true`)
- gimp
- inkscape
- krita
- kdenlive

### Password & Notes Management (3)
- keepassxc
- bitwarden
- zim

### Media Players (3)
- vlc
- mpv
- gthumb

### Monitoring Tools (7)
- btop
- htop
- nvtop
- plasma-systemmonitor
- openrgb
- corectrl
- glances

### Security & Backup (2)
- veracrypt
- timeshift

### Desktop Helpers & Themes (7)
- kvantum
- papirus-icon-theme
- kwalletmanager
- redshift
- flameshot
- alacritty

### AUR Packages (Always Installed - 5)
- swww
- cliphist
- grimblast-git
- mpvpaper
- waybar-hyprland-git

### AUR Office Packages (4)
- masterpdfeditor-free
- onlyoffice-bin
- logseq-desktop-bin
- zotero-bin

### AUR Browser Packages (1)
- google-chrome

### AUR Secondary Browsers (Optional - 2 packages, if enabled)
- brave-bin
- zen-browser-bin

### AUR Communication Packages (3)
- slack-desktop
- discord
- zoom
- mattermost-desktop

### AUR Cloud Sync Packages (Optional - 3 packages, if enabled)
- dropbox
- google-drive-ocamlfuse
- mega-cmd-bin

### AUR Streaming Packages (Optional - 4 packages, if enabled)
- shotcut
- rustdesk-bin
- anydesk-bin
- gpu-screen-recorder

### AUR Notes Packages (3)
- obsidian
- joplin-appimage
- standardnotes

### AUR Media Packages (3)
- spotify-launcher
- stremio
- smarttube-beta-bin

### AUR Misc Packages (1)
- parsec-bin

### Flatpak Applications (1)
- com.microsoft.Teams

---

## Gaming Role

**Location:** `system/roles/gaming/`

The gaming role installs Steam, Wine, gaming performance tools, and related packages.

### Steam & Wine (5)
- steam
- steam-devices
- wine-staging
- wine-gecko
- wine-mono

### Controllers (2)
- joyutils
- xorg-xinput

### Performance & Compositors (7)
- gamemode
- lib32-gamemode
- gamescope
- mangohud
- lib32-mangohud
- vkbasalt
- vkd3d-proton

### Vulkan & GPU Tools (10)
- vulkan-icd-loader
- vulkan-tools
- vulkan-validation-layers
- lib32-vulkan-icd-loader
- lib32-vulkan-intel
- lib32-vulkan-radeon
- mesa-utils
- lib32-mesa
- glmark2
- vkmark

### Streaming & Recording (1)
- obs-studio

### AUR Core Gaming Packages (9)
- protonup-qt
- protontricks
- winetricks-git
- heroic-games-launcher-bin
- bottles
- itch-bin
- legendary
- dxvk-bin
- goverlay

### AUR Controller Packages (2)
- xpadneo-dkms
- ds4drv

### AUR Media & Streaming Packages (8)
- obs-gstreamer
- obs-vkcapture
- latencyflex
- moonlight-qt
- sunshine-bin
- jellyfin

### AUR Apollo (Optional - 1 package, if `install_apollo: true`)
- apollo-bin

---

## NVIDIA Role

**Location:** `system/roles/nvidia/`

The NVIDIA role installs GPU drivers and CUDA stack (optional).

### NVIDIA Driver Stack (10)
- nvidia
- nvidia-lts
- nvidia-utils
- nvidia-settings
- nvidia-prime
- egl-wayland
- nv-codec-headers
- opencl-nvidia
- lib32-nvidia-utils
- lib32-opencl-nvidia

### CUDA Stack (Optional - 4 packages, if `enable_cuda_stack: true`)
- cuda
- cuda-tools
- cudnn
- clinfo

### AUR Packages (1)
- goverlay

### Kernel Modules (Added to mkinitcpio)
- nvidia
- nvidia_modeset
- nvidia_uvm
- nvidia_drm

---

## Package Summary

### Total Core Packages: ~279-319 packages

**Breakdown by Category:**

| Role | Core Packages | AUR Packages | Optional Packages | Total Range |
|------|---------------|-------------|------------------|-------------|
| Base | 59 | 0 | 2-8 | 61-67 |
| Development | 40 | 22 | 12 | 74 |
| Productivity | 50 | 20 | 10 | 80 |
| Gaming | 25 | 19 | 1 | 45 |
| NVIDIA | 10 | 1 | 4 | 15 |
| **Totals** | **184** | **62** | **29-39** | **275-285** |

### Notes:

1. **Optional Packages**: The actual count depends on feature flags:
   - `enable_docker`, `enable_libvirt`, `enable_database_servers`, `enable_gui_db_clients`, `enable_data_platforms`
   - `enable_creative_suite`, `enable_cuda_stack`, `install_apollo`
   - Various AUR browser, communication, sync, and streaming options

2. **Conditional Packages**: 
   - Microcode package selected based on CPU vendor (AMD or Intel)
   - Power management package selected based on user preference (power-profiles-daemon or tlp)
   - Language runtime packages may be overridden per user configuration

3. **AUR Helper**: All AUR packages are installed via `yay` by default (configurable)

4. **Services Enabled**:
   - Base: NetworkManager, Bluetooth, CUPS, UFW, Reflector, PCS Daemon, systemd-timesyncd
   - Development: SSH daemon, Docker (optional), libvirt (optional)
   - Productivity: Syncthing
   - NVIDIA: nvidia-persistenced

5. **User Configuration**: Actual installation depends on the target system type selected:
   - `home_desktop.yml`
   - `minimal.yml`
   - `work_laptop.yml`

---

## Installation Playbooks

### Main Playbook
**Location:** `system/playbooks/site.yml`

Orchestrates all role installations based on inventory and variables.

### Individual Playbooks
- `base.yml` - Core system packages
- `development.yml` - Development tools and runtimes
- `productivity.yml` - Desktop and productivity applications
- `gaming.yml` - Gaming and entertainment packages
- `nvidia.yml` - NVIDIA GPU drivers and utilities

---

## How to Use This Document

1. **Check Overall Inventory**: Review which packages are installed for each role
2. **Customization**: Modify variables in `system/inventory/group_vars/` to enable/disable optional packages
3. **Feature Selection**: Adjust playbook inclusion in `system/playbooks/site.yml` to customize installation
4. **Add New Packages**: Edit the corresponding `vars/main.yml` file in each role to add new packages

