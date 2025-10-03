# Arch Setup Checklist

## General Machine Setup

### Base System

- findutils, coreutils, grep, sed — essential CLI utilities
- jq — command-line JSON processor
- bc — command-line calculator
- grim — screenshot utility
- libnotify — desktop notifications
- swaync — notification daemon
- Fancontrol — fan curve management
- OpenRGB — peripheral lighting control
- qt5-wayland — Qt Wayland support
- qt6-wayland — Qt Wayland support
- networkmanager, network-manager-applet — network management (enable service)
- blueman — Bluetooth manager
- systemd-timesyncd or chrony — time synchronization
- ufw (optional gufw) — firewall management
- intel-ucode/amd-ucode — CPU microcode updates
- tlp or power-profiles-daemon — power management (laptops)
- btrfs-progs and snapper — Btrfs tooling and snapshots
- reflector — refresh pacman mirrors
- yay (or other AUR helper) — AUR package management
- cups and system-config-printer — printing support

### Development Tools

- base-devel — makepkg build prerequisites
- git, gnupg — version control and signing
- ripgrep, fd, bat — enhanced search and file viewing
- helix or neovim — terminal text editors
- VS Code — primary IDE
- alacritty or kitty — GPU-accelerated terminal emulators
- direnv — per-project environment management
- python-pip, nodejs/npm, go, rustup — language toolchains
- podman or docker, docker-compose — containers
- qemu-desktop, virt-manager — virtualization stack

### Productivity & Desktop Experience

- Hyprland — Wayland compositor
- waybar-hyprland-git — status bar for Hyprland
- swww — wallpaper setter
- mpvpaper — animated wallpaper setter
- rofi — application launcher
- Spotify
- Discord
- Calibre
- Fonts:
  - ttf-jetbrains-mono
  - ttf-jetbrains-mono-nerd
  - noto-fonts-emoji
  - ttf-firacode-nerd
  - ttf-nerd-fonts-symbols
- qt5ct, qt6ct, kvantum — Qt theming controls
- papirus-icon-theme — icon theme
- wl-clipboard, cliphist — Wayland clipboard tooling
- xdg-desktop-portal-hyprland — portal integration for Hyprland
- polkit-gnome or lxqt-policykit — authentication agent
- pavucontrol or helvum — audio controls for PipeWire
- grimblast, slurp — advanced screenshot and region capture
- thunar or dolphin — file manager
- tmux — terminal multiplexer
- obsidian or logseq — knowledge management
- bitwarden or keepassxc — password management
- Firefox, Brave, Zen Browser — web browsers

## Bonus: Gaming & Graphics

### Gaming Stack

- Steam
- Proton
- Lutris — multi-store game launcher
- Heroic Games Launcher — Epic/GOG integration
- protontricks — per-title compatibility tweaks
- gamemode — performance tuning daemon
- mangohud — in-game performance overlay
- wine, wine-gecko, wine-mono — Windows compatibility layers

### NVIDIA Enhancements

- NVIDIA drivers (see `arch-home-desktop/04-nvidia-drivers.sh`)
- nvidia-settings, nvidia-utils, lib32-nvidia-utils — control panel and 32-bit libraries
- vulkan-icd-loader, lib32-vulkan-icd-loader — Vulkan support
- nvidia-prime or envycontrol — GPU switching on hybrid systems

### Game Streaming

- Apollo
- Sunshine — self-hosted game streaming server
- Parsec — low-latency remote desktop for games
- obs-studio with wlrobs — Wayland capture and streaming

## Optional Software

### Browsers

- Zen Browser
- Google Chrome

### Communication

- Element-desktop — Matrix client
- Slack
- Zoom

### Media & Creativity

- VLC
- mpv
- gthumb or shotwell — photo management

### Backup & Sync

- restic or borg — backup tooling
- timeshift — system snapshots
- syncthing — file synchronization
- mega-cmd — cloud storage CLI

### System Monitoring & Utilities

- btop, htop, glances — system monitoring dashboards
- nvtop — NVIDIA GPU monitoring
- reflector timer — keep pacman mirrors fresh

### Developer Extras

- docker-compose — compose file workflow (if not using podman)
- poetry — Python dependency management
- nvm — manage Node.js versions

### Knowledge & Productivity

- Zotero — reference management
- Anki — spaced repetition flashcards

## Post-Install Tasks

- Set up desktop
- Back up configuration
- Enable key services (NetworkManager, bluetooth, cups, PipeWire, tlp or power-profiles, ufw)
- Configure time sync and verify hardware clock (systemd-timesyncd or chrony)
- Test printing and scanning setup
- Initialize dotfiles management (chezmoi, yadm, or bare git) and push configs
- Configure backups (restic, borg, timeshift) and verify restore workflow
- Schedule reflector timer and create pacman hook automation
- Style Hyprland/Waybar and commit theming to version control
- Document GPU driver tweaks and performance profiles
- Run security and health checks (lynis audit, optional clamav scan)
- Ricing? → [video walkthrough](https://youtu.be/NrRVr-kysko?si=f0jFTdKK_A1--tnY)
