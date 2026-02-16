# Post-Installation Guide

This guide covers the recommended steps to take after running the linux-setup-scripts installation.

## 1. Reboot the System

After installation completes, reboot to ensure all kernel modules, services, and drivers are properly loaded:

```bash
sudo reboot
```

## 2. Verify Critical Services

Check that essential services are running correctly:

```bash
# Network connectivity
systemctl status NetworkManager

# Bluetooth (if enabled)
systemctl status bluetooth

# Power management (laptops)
systemctl status tlp

# Printing services (if enabled)
systemctl status cups

# Audio system
systemctl --user status pipewire
systemctl --user status wireplumber
```

## 3. Configure Desktop Environment

### For Hyprland Users
```bash
# Start Hyprland
Hyprland
```

### For Other Desktop Environments
Configure your display manager or desktop session as needed.

## 4. Set Up Development Environment

### Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Generate SSH Keys
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
```

### Configure Shell
If Oh My Zsh was installed, set Zsh as your default shell:
```bash
chsh -s /usr/bin/zsh
```

## 5. Apply Dotfiles/Configurations

Dotfiles are included in this repository under `arch-setup/dotfiles/` with automated installers.

### Automated Installation (Recommended)

From the repository root:

```bash
# Interactive menu to choose what to install
bash arch-setup/dotfiles/install.sh
```

Or install specific components directly:

```bash
bash arch-setup/dotfiles/install-bash.sh      # Lightweight shell config
bash arch-setup/dotfiles/install-zsh.sh       # Feature-rich Zsh + Oh-My-Zsh
bash arch-setup/dotfiles/install-nvim.sh      # Neovim IDE setup
bash arch-setup/dotfiles/install-hyprland.sh  # Hyprland window manager
bash arch-setup/dotfiles/install-sway.sh      # Sway window manager
```

**What the scripts do:**
- Automatically back up existing configurations
- Copy dotfiles to correct locations
- Install missing dependencies (Oh-My-Zsh, language servers, etc.)
- Provide post-install instructions

### Manual Installation

If you prefer to copy files manually:

```bash
# Shell configuration - choose one
cp arch-setup/dotfiles/bash/.bashrc ~/.bashrc
# OR
cp arch-setup/dotfiles/zsh/.zshrc ~/.zshrc

# Neovim
mkdir -p ~/.config/nvim
cp -r arch-setup/dotfiles/nvim/* ~/.config/nvim/

# Hyprland
mkdir -p ~/.config/hypr ~/.config/waybar
cp arch-setup/dotfiles/hyprland/hyprland.conf ~/.config/hypr/
cp arch-setup/dotfiles/hyprland/waybar-* ~/.config/waybar/

# Sway
mkdir -p ~/.config/sway ~/.config/waybar
cp arch-setup/dotfiles/sway/config ~/.config/sway/
cp arch-setup/dotfiles/sway/waybar-* ~/.config/waybar/
```

**See `arch-setup/dotfiles/README.md` for full documentation on installation, prerequisites, customization, and troubleshooting.**

## 6. Configure Applications

### VS Code
- Install extensions
- Sync settings if using GitHub/Microsoft account
- Configure workspace settings

### Communication Apps
- **Discord**: Log into account, configure voice settings
- **Slack**: Join workspaces, configure notifications

### Browsers
- Import bookmarks and passwords
- Install extensions
- Configure sync if using browser accounts

### Gaming (if enabled)
- **Steam**: Log in, enable Proton for Windows games
- **Heroic**: Configure Epic Games and GOG accounts
- **Controller setup**: Test gamepad functionality

### Media Applications
- **Spotify**: Log into account
- **VLC/MPV**: Test video/audio playback
- **OBS**: Configure scenes and sources

## 7. Test Key Functionality

### Audio/Video
```bash
# Test audio output
speaker-test -t wav -c 2

# Test microphone (if needed)
arecord -f cd -d 5 test.wav && aplay test.wav
```

### Graphics/GPU
```bash
# Test OpenGL
glxinfo | grep "OpenGL renderer"

# NVIDIA users - test CUDA (if installed)
nvidia-smi

# Test Vulkan
vulkaninfo | head -20
```

### Network
```bash
# Test connectivity
ping -c 4 google.com

# Test DNS resolution
nslookup github.com
```

### Development Tools
```bash
# Test compilers
gcc --version
rustc --version
node --version
python --version

# Test containerization
podman --version
docker --version  # if Docker was enabled
```

## 8. Performance Optimization

### Enable Services (as needed)
```bash
# Gaming performance
sudo systemctl enable gamemode

# NVIDIA users
sudo systemctl enable nvidia-persistenced

# Laptop users
sudo systemctl enable tlp
```

### Configure Firewall
```bash
# Enable and configure UFW
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## 9. Create System Backup

Create a baseline system snapshot:
```bash
# Using Timeshift (if installed)
sudo timeshift --create --comments "Post-installation baseline"

# Or create a manual backup of important configs
tar -czf ~/backup-configs-$(date +%Y%m%d).tar.gz \
    ~/.config \
    ~/.bashrc \
    ~/.zshrc \
    /etc/pacman.conf \
    /etc/makepkg.conf
```

## 10. Security Hardening

### Update System
```bash
sudo pacman -Syu
```

### Configure Automatic Updates (optional)
```bash
# Enable automatic security updates
sudo systemctl enable systemd-timesyncd
```

### Set Up Secure Boot (if desired)
Follow Arch Wiki guidance for your specific setup.

## 11. Troubleshooting Common Issues

### Audio Not Working
```bash
# Restart audio services
systemctl --user restart pipewire
systemctl --user restart wireplumber
```

### Graphics Issues
```bash
# NVIDIA users - check driver status
nvidia-smi
dmesg | grep nvidia

# General graphics troubleshooting
lspci | grep VGA
```

### Network Issues
```bash
# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check interface status
ip link show
```

## 12. Next Steps

- Join the Arch Linux community forums
- Set up automated backups
- Customize your desktop environment
- Install additional software as needed
- Consider learning about systemd services and timers

## Useful Resources

- [Arch Wiki](https://wiki.archlinux.org/)
- [Hyprland Documentation](https://hyprland.org/)
- [Repository Issues](https://github.com/maxabbot/linux-setup-scripts/issues)

---

**Note**: This setup script configures a comprehensive development and productivity environment. Some features may be disabled by default - check the environment variables in your profile script to enable additional functionality.