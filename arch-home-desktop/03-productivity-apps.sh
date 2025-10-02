#!/bin/bash
# Productivity applications and office tools
# Windows replacements and standard work programs

set -e

echo "=========================================="
echo "Installing Productivity Applications"
echo "=========================================="

# Office Suite (LibreOffice as MS Office replacement)
echo "Installing office suite..."
sudo pacman -S --noconfirm --needed \
    libreoffice-fresh \
    libreoffice-fresh-en-us

# PDF Tools
echo "Installing PDF tools..."
sudo pacman -S --noconfirm --needed \
    okular \
    pdfarranger \
    ghostscript

# Web Browsers
echo "Installing web browsers..."
sudo pacman -S --noconfirm --needed \
    firefox \
    chromium

yay -S --noconfirm --needed \
    google-chrome

# Communication Tools
echo "Installing communication tools..."
yay -S --noconfirm --needed \
    slack-desktop \
    discord \
    zoom \
    teams-for-linux

# Email Client
echo "Installing email client..."
sudo pacman -S --noconfirm --needed \
    thunderbird

# File Management & Cloud Storage
echo "Installing file management and cloud tools..."
sudo pacman -S --noconfirm --needed \
    thunar \
    dolphin \
    ark

yay -S --noconfirm --needed \
    dropbox \
    google-drive-ocamlfuse

# Image Editing & Graphics (GIMP as Photoshop replacement)
echo "Installing image editing tools..."
sudo pacman -S --noconfirm --needed \
    gimp \
    inkscape \
    imagemagick

# Screenshot & Screen Recording
echo "Installing screenshot and recording tools..."
sudo pacman -S --noconfirm --needed \
    flameshot \
    obs-studio

# Password Manager
echo "Installing password manager..."
sudo pacman -S --noconfirm --needed \
    keepassxc

# Note-taking & Documentation
echo "Installing note-taking tools..."
yay -S --noconfirm --needed \
    obsidian \
    joplin-appimage

# Video Conferencing & Media
echo "Installing media players..."
sudo pacman -S --noconfirm --needed \
    vlc \
    mpv

# System Monitoring
echo "Installing system monitoring tools..."
sudo pacman -S --noconfirm --needed \
    htop \
    btop \
    iotop \
    nethogs

echo "Productivity applications installation complete!"
