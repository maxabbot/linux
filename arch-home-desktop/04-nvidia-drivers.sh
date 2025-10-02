#!/bin/bash
# NVIDIA RTX 4070 drivers and support
# Installs proprietary NVIDIA drivers and utilities

set -e

echo "=========================================="
echo "Installing NVIDIA RTX 4070 Drivers"
echo "=========================================="

# Install NVIDIA proprietary drivers
echo "Installing NVIDIA drivers..."
sudo pacman -S --noconfirm --needed \
    nvidia \
    nvidia-utils \
    nvidia-settings \
    lib32-nvidia-utils

# Install CUDA for GPU computing
echo "Installing CUDA toolkit..."
sudo pacman -S --noconfirm --needed \
    cuda \
    cudnn

# Install Vulkan support
echo "Installing Vulkan support..."
sudo pacman -S --noconfirm --needed \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-tools

# Install OpenCL support
echo "Installing OpenCL support..."
sudo pacman -S --noconfirm --needed \
    opencl-nvidia \
    lib32-opencl-nvidia

# Enable nvidia-drm modeset (required for Wayland support)
echo "Configuring NVIDIA kernel module parameters..."
if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# Add nvidia modules to initramfs
echo "Adding NVIDIA modules to initramfs..."
if ! grep -q "nvidia nvidia_modeset nvidia_uvm nvidia_drm" /etc/mkinitcpio.conf; then
    sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
fi

# Enable nvidia-persistenced for better performance
echo "Enabling NVIDIA persistence daemon..."
sudo systemctl enable nvidia-persistenced.service

# Install GPU monitoring tools
echo "Installing GPU monitoring tools..."
sudo pacman -S --noconfirm --needed \
    nvtop

yay -S --noconfirm --needed \
    gpu-screen-recorder

echo "=========================================="
echo "NVIDIA driver installation complete!"
echo "Please reboot your system for changes to take effect."
echo "=========================================="
