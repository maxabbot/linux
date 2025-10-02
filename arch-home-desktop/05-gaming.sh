#!/bin/bash
# Gaming setup with Steam, Proton, and related tools
# Includes Apollo streaming and other gaming utilities

set -e

echo "=========================================="
echo "Installing Gaming Software"
echo "=========================================="

# Enable multilib repository (needed for 32-bit games)
echo "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy
fi

# Install Steam with Proton support
echo "Installing Steam..."
sudo pacman -S --noconfirm --needed \
    steam \
    lib32-mesa \
    lib32-vulkan-icd-loader \
    lib32-vulkan-intel \
    lib32-vulkan-radeon

# Install Wine and Proton-related tools
echo "Installing Wine and Proton tools..."
sudo pacman -S --noconfirm --needed \
    wine \
    wine-mono \
    wine-gecko \
    winetricks

# Install ProtonUp-Qt for easy Proton-GE management
echo "Installing ProtonUp-Qt..."
yay -S --noconfirm --needed \
    protonup-qt

# Install Lutris (game launcher for various sources)
echo "Installing Lutris..."
sudo pacman -S --noconfirm --needed \
    lutris

# Install Apollo streaming (Moonlight)
echo "Installing Moonlight for game streaming..."
yay -S --noconfirm --needed \
    moonlight-qt

# Install game controllers support
echo "Installing game controller support..."
sudo pacman -S --noconfirm --needed \
    gamemode \
    lib32-gamemode \
    gamescope

# Install Discord with Rich Presence
echo "Installing Discord (already installed in productivity, skipping)..."

# Install MangoHud for FPS overlay and performance monitoring
echo "Installing MangoHud..."
sudo pacman -S --noconfirm --needed \
    mangohud \
    lib32-mangohud

# Install GOverlay (MangoHud GUI configurator)
echo "Installing GOverlay..."
yay -S --noconfirm --needed \
    goverlay

# Install additional game launchers
echo "Installing additional game launchers..."
yay -S --noconfirm --needed \
    heroic-games-launcher-bin

# Install Game streaming tools
echo "Installing game streaming tools..."
sudo pacman -S --noconfirm --needed \
    obs-studio

# Install Bottles (Windows app manager)
echo "Installing Bottles..."
yay -S --noconfirm --needed \
    bottles

# Enable gamemode service
sudo systemctl --user enable gamemoded

echo "=========================================="
echo "Gaming software installation complete!"
echo ""
echo "Next steps:"
echo "1. Launch Steam and enable Proton in Settings > Steam Play"
echo "2. Use ProtonUp-Qt to install Proton-GE for better compatibility"
echo "3. Configure Moonlight with your gaming PC for streaming"
echo "4. Install game launchers: Lutris, Heroic Games Launcher"
echo "5. Use MangoHud to monitor game performance (run games with 'mangohud %command%')"
echo "6. Configure Discord Rich Presence for supported games"
echo "=========================================="
