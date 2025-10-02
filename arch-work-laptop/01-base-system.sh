#!/bin/bash
# Base system setup for Arch Linux work laptop
# This script should be run after initial Arch installation

set -e

echo "=========================================="
echo "Arch Linux Work Laptop - Base System Setup"
echo "=========================================="

# Update system
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install essential system utilities
echo "Installing essential system utilities..."
sudo pacman -S --noconfirm --needed \
    base-devel \
    git \
    wget \
    curl \
    htop \
    neofetch \
    tmux \
    vim \
    nano \
    unzip \
    zip \
    p7zip \
    tar \
    rsync \
    openssh \
    man-db \
    man-pages \
    bash-completion \
    networkmanager \
    network-manager-applet

# Install AUR helper (yay)
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

echo "Base system setup complete!"
