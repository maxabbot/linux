# Arch Linux Home Desktop Setup

This folder contains setup scripts for configuring an Arch Linux home desktop PC with development tools, productivity applications, gaming support (Steam/Proton, Apollo streaming), and NVIDIA RTX 4070 drivers.

## Prerequisites

- Fresh Arch Linux installation
- Internet connection
- User account with sudo privileges
- NVIDIA RTX 4070 graphics card

## Scripts Overview

### 01-base-system.sh
Installs essential system utilities and sets up the AUR helper (yay).

**Includes:**
- System utilities (git, wget, curl, htop, etc.)
- Compression tools
- Network tools
- Yay AUR helper

### 02-development-tools.sh
Installs comprehensive development environment for data and software engineering.

**Includes:**
- **Programming Languages:** Python, Node.js, Go, Rust, Java, C/C++
- **Data Science Tools:** NumPy, Pandas, Matplotlib, Scikit-learn, TensorFlow, PyTorch, Jupyter
- **Databases:** PostgreSQL, MariaDB, Redis, SQLite
- **Container Tools:** Docker, Docker Compose, kubectl
- **IDEs:** VS Code, PyCharm Community, IntelliJ IDEA Community
- **Version Control:** Git, Git LFS, GitHub CLI
- **Development Tools:** Postman, DBeaver

### 03-productivity-apps.sh
Installs productivity applications and Windows program replacements.

**Includes:**
- **Office Suite:** LibreOffice (MS Office replacement)
- **Browsers:** Firefox, Chromium, Google Chrome
- **Communication:** Slack, Discord, Zoom, Teams
- **Email:** Thunderbird
- **Cloud Storage:** Dropbox, Google Drive
- **Image Editing:** GIMP (Photoshop replacement), Inkscape
- **Screen Tools:** Flameshot, OBS Studio
- **Password Manager:** KeePassXC
- **Note-taking:** Obsidian, Joplin
- **Media Players:** VLC, MPV
- **System Monitoring:** htop, btop, iotop

### 04-nvidia-drivers.sh
Installs NVIDIA RTX 4070 proprietary drivers and GPU computing support.

**Includes:**
- **NVIDIA Drivers:** nvidia, nvidia-utils, nvidia-settings
- **GPU Computing:** CUDA toolkit, cuDNN
- **Graphics APIs:** Vulkan, OpenCL (with 32-bit support)
- **Kernel Configuration:** Enables nvidia-drm modeset for Wayland
- **Monitoring Tools:** nvtop, gpu-screen-recorder
- **Performance:** NVIDIA persistence daemon

### 05-gaming.sh
Installs gaming platform with Steam, Proton, and game streaming tools.

**Includes:**
- **Gaming Platforms:** Steam with Proton, Lutris, Heroic Games Launcher
- **Proton Tools:** Wine, Winetricks, ProtonUp-Qt (for Proton-GE)
- **Game Streaming:** Moonlight-Qt (Apollo streaming client)
- **Game Optimization:** GameMode, Gamescope, MangoHud, GOverlay
- **Windows Apps:** Bottles (Windows app manager)
- **Streaming:** OBS Studio for broadcasting
- **32-bit Support:** Multilib repository enabled

## Usage

Run the scripts in order:

```bash
# Make scripts executable
chmod +x *.sh

# 1. Install base system and AUR helper
./01-base-system.sh

# 2. Install development tools
./02-development-tools.sh

# 3. Install productivity applications
./03-productivity-apps.sh

# 4. Install NVIDIA RTX 4070 drivers
./04-nvidia-drivers.sh

# 5. Install gaming software
./05-gaming.sh
```

## Important Notes

### NVIDIA Driver Installation
- **REBOOT REQUIRED** after running script 04 (NVIDIA drivers)
- The script configures kernel parameters and initramfs for optimal NVIDIA support
- Wayland support is enabled via nvidia-drm.modeset=1

### Gaming Setup
- Multilib repository is automatically enabled for 32-bit game support
- Enable Steam Play (Proton) in Steam Settings after installation
- Use ProtonUp-Qt to install Proton-GE for better game compatibility
- Launch games with MangoHud using: `mangohud %command%` in Steam launch options

### Apollo Streaming (Moonlight)
- Moonlight-Qt is the open-source client for NVIDIA GameStream/Sunshine
- Requires a gaming PC with GeForce Experience or Sunshine server
- Configure the host PC IP in Moonlight settings

## Post-Installation

After running all scripts:

### Development Setup
1. Configure Git credentials
2. Set up SSH keys
3. Configure IDE preferences
4. Set up database passwords

### Gaming Setup
1. **Steam:**
   - Launch Steam and log in
   - Enable Proton: Settings → Steam Play → Enable Steam Play for all other titles
   - Install Proton-GE via ProtonUp-Qt for better compatibility

2. **Moonlight Streaming:**
   - Configure host PC with NVIDIA GameStream or Sunshine
   - Add host PC in Moonlight-Qt
   - Test connection and optimize settings

3. **MangoHud:**
   - Configure via GOverlay GUI
   - Add `mangohud %command%` to Steam game launch options
   - Customize overlay position and metrics

4. **Game Controllers:**
   - Controllers should work automatically with Steam Input
   - Configure in Steam Settings → Controller

### NVIDIA Configuration
1. Run `nvidia-settings` to configure displays and GPU settings
2. Enable G-SYNC if supported by your monitor
3. Monitor GPU with `nvtop` command

## Performance Tips

- Use GameMode for optimized game performance: Games launched through Steam/Lutris use it automatically
- Use MangoHud to monitor FPS and performance metrics
- For maximum performance, close unnecessary background applications
- Use Gamescope for custom resolutions and frame rate limiting
- Enable NVIDIA power management in nvidia-settings

## Troubleshooting

### NVIDIA Issues
- If screen is black after driver installation, boot into recovery and check logs
- Verify driver loaded: `lsmod | grep nvidia`
- Check NVIDIA GPU: `nvidia-smi`

### Gaming Issues
- Proton compatibility: Check [ProtonDB](https://www.protondb.com/) for game-specific fixes
- For stubborn games, try different Proton versions (GE versions often work better)
- Enable debug logs in Steam: `PROTON_LOG=1 %command%`

### General Issues
- Check logs: `journalctl -xe`
- Ensure sufficient disk space
- Consult Arch Wiki for specific package issues
- Some AUR packages may require manual intervention

## Resources

- [Arch Wiki - NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- [Arch Wiki - Steam](https://wiki.archlinux.org/title/Steam)
- [ProtonDB](https://www.protondb.com/) - Game compatibility database
- [Moonlight Docs](https://moonlight-stream.org/) - Game streaming setup
- [MangoHud](https://github.com/flightlessmango/MangoHud) - Performance overlay
