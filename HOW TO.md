Goal
Install a fully working Arch system onto a USB stick (portable install) and then boot that USB inside a VM to finish configuration and test.

Assumptions & safety

* Host has virtualization (QEMU/KVM or VirtualBox) and root access.
* USB device is at least 8GB (16–32GB recommended).
* You understand replacing device names (e.g. /dev/sdX) will destroy data on that device. Replace placeholders carefully.
* Commands use a Linux host; Windows/macOS notes are included where needed.

High level options (pick one)
A) **Recommended / safest** — install Arch inside a VM to a disk image, test there, then `dd` that raw image to the USB. No risk of clobbering host disks while installing.
B) **Direct** — boot Arch installer on a machine (or VM with raw disk access) and install directly onto /dev/sdX (the physical USB). Faster but riskier if you point at the wrong device.

Part 0 — get the Arch ISO

1. Download the latest Arch ISO from [https://archlinux.org/](https://archlinux.org/) (or use your preferred mirror).
2. Verify checksum (example):
   `sha256sum archlinux-*.iso` and compare with the checksum file from the site.

---

PART 1 — Create a target disk (A: image for VM or B: physical device)

Option A — create a raw image to install into via VM

```bash
# Example: create a 32GB raw image (size as you want)
qemu-img create -f raw ~/arch-usb.img 32G
```

Option B — identify the USB device for direct install

```bash
# On Linux, before plugging in and after plugging in, use:
lsblk
# Find the new device (e.g. /dev/sdb). We'll call it /dev/sdX in steps below.
```

**Always double-check the device name.**

---

PART 2 — Boot Arch installer in a VM and attach the target

Option A (image): boot the Arch ISO and attach the raw image as a disk

```bash
sudo qemu-system-x86_64 -enable-kvm -m 4G \
  -boot d -cdrom archlinux-*.iso \
  -drive file=~/arch-usb.img,format=raw,if=virtio
```

The installer will see the target disk as `/dev/vda` inside the VM.

Option B (physical USB attached as raw disk to VM)

* **QEMU** (Linux host): make sure USB is unmounted on host, then:

```bash
# Replace /dev/sdX with your USB device
sudo qemu-system-x86_64 -enable-kvm -m 4G \
  -boot d -cdrom archlinux-*.iso \
  -drive file=/dev/sdX,format=raw,if=virtio
```

* **VirtualBox** (Linux host): create a VMDK that maps the raw disk, then attach to VM:

```bash
# Unmount /dev/sdX partitions first.
sudo VBoxManage internalcommands createrawvmdk -filename ~/usb.vmdk -rawdisk /dev/sdX
# Add ~/usb.vmdk to your VirtualBox VM as a storage disk and boot the VM from the Arch ISO.
```

* **VirtualBox on Windows**: use `\\.\PhysicalDriveN` in the `createrawvmdk` command (run as Admin). See VirtualBox docs for exact syntax.

---

PART 3 — Partition & format the target (GPT, UEFI-friendly)
This example uses a small EFI partition + root. Adjust swap/home as you like.

Inside the Arch live environment (in VM), assuming target is `/dev/vda` (image) or `/dev/sdX` (physical):

```bash
# Replace device with /dev/vda or /dev/sdX as appropriate
PART=/dev/vda   # or /dev/sdX

# Create GPT + partitions:
parted $PART --script mklabel gpt \
  mkpart primary fat32 1MiB 513MiB \
  set 1 boot on \
  mkpart primary ext4 513MiB 100%

# Example result:
#  /dev/vda1  -> EFI (512MiB)
#  /dev/vda2  -> Linux root (rest)
```

Format:

```bash
mkfs.fat -F32 ${PART}1
mkfs.ext4 ${PART}2
# optional swap:
# fallocate -l 4G /swapfile or create a swap partition if you prefer
```

Mount:

```bash
mount ${PART}2 /mnt
mkdir -p /mnt/boot
mount ${PART}1 /mnt/boot
```

---

PART 4 — Base install (pacstrap) and basic config
From the live environment:

```bash
# Install base system + network manager + common tools
pacstrap /mnt base linux linux-firmware vim networkmanager
# Add open-iscsi, sudo, efibootmgr, grub if desired
```

Generate fstab:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Enter chroot:

```bash
arch-chroot /mnt
```

Inside chroot — basic settings:

```bash
# Timezone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "arch-usb" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch-usb.localdomain arch-usb
EOF

# Set root password
passwd
```

Create a normal user and give sudo:

```bash
pacman -S sudo
useradd -m -G wheel -s /bin/bash youruser
passwd youruser
EDITOR=vim visudo   # uncomment %wheel ALL=(ALL) ALL
```

Enable network manager:

```bash
systemctl enable NetworkManager
```

---

PART 5 — Install a bootloader (UEFI recommended for modern systems)

Option 1 — **systemd-boot** (UEFI, simple & portable for removable media)

```bash
# inside chroot
bootctl --path=/boot install

# get UUID of root partition
blkid /dev/vda2    # or /dev/sdX2 -> copy UUID=

# Create loader.conf
cat > /boot/loader/loader.conf <<EOF
default arch
timeout 3
editor  no
EOF

# Create entry; replace ROOT_UUID with the UUID value
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=ROOT_UUID rw
EOF
```

`bootctl --path=/boot install` will place the EFI file in the ESP. For maximum removable-device portability, systemd-boot installs a loader in the removable path so many UEFI firmware will boot it.

Option 2 — **GRUB** (UEFI + BIOS compatibility if desired)

```bash
pacman -S grub efibootmgr
# For UEFI:
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# For BIOS (optional, for legacy machines):
grub-install --target=i386-pc /dev/vda   # or /dev/sdX  (only if you want legacy support)
grub-mkconfig -o /boot/grub/grub.cfg
```

Notes:

* `grub-install` for i386-pc on GPT may require a BIOS boot partition; if you want universal compatibility you can create both the EFI entry and an MBR with GRUB (advanced).

---

PART 6 — finish, exit, copy image to USB (if you used image method)
Inside chroot:

```bash
# update initramfs if you added microcode, etc
mkinitcpio -P
exit
```

Unmount:

```bash
umount -R /mnt
```

If you installed into a VM raw image (`~/arch-usb.img`) and you want to write that to the physical USB:

```bash
# On the host, make sure the USB is unmounted and replace /dev/sdX carefully
sudo dd if=~/arch-usb.img of=/dev/sdX bs=4M status=progress conv=fdatasync
# or with pv:
pv ~/arch-usb.img | sudo dd of=/dev/sdX bs=4M conv=fdatasync
```

If you installed directly to the USB device in step 3/4 (option B), the device is already ready — skip dd.

---

PART 7 — Boot the USB inside a VM for configuration/testing
**Important:** Unmount the USB on the host before giving VM raw access.

QEMU (Linux host) — boot directly from the physical USB:

```bash
# Make sure /dev/sdX partitions are unmounted on host
sudo qemu-system-x86_64 -enable-kvm -m 4G \
  -drive file=/dev/sdX,format=raw,if=virtio \
  -boot order=c
```

If you used an image, you can attach the image instead:

```bash
sudo qemu-system-x86_64 -enable-kvm -m 4G -drive file=~/arch-usb.img,format=raw,if=virtio -boot c
```

VirtualBox — use the raw VMDK you created earlier:

1. Create the `usb.vmdk` mapping the physical disk (see Part 2).
2. Attach the `usb.vmdk` to the VM as the primary disk.
3. In VM settings → System → enable EFI if your USB uses UEFI.
4. Boot the VM.

virt-manager — create a VM and attach `/dev/sdX` as the disk (requires root privileges).

Inside the VM — tests & configuration

* Login as your user or root.
* Update the system: `sudo pacman -Syu`
* Install packages you want (desktop environment, audio, drivers): e.g.
  `sudo pacman -S xorg xfce4 lightdm lightdm-gtk-greeter` then `sudo systemctl enable lightdm`
* Enable other services: `sudo systemctl enable sshd` etc.
* Check networking: `nmcli device status` (NetworkManager).

---

Troubleshooting & tips

* If VM doesn’t boot in UEFI mode, enable EFI/OVMF for the VM (VirtualBox: "Enable EFI"; QEMU: use `-bios /usr/share/ovmf/OVMF_CODE.fd` or install OVMF on your distro).
* If you want the USB to boot both UEFI and BIOS systems, install GRUB for both targets (advanced) or keep a small legacy boot stub — more complexity.
* For portability: use UUIDs for `root=UUID=...` in loader entries; `blkid` shows UUIDs.
* Always unmount the USB from host before giving the VM raw access or dd-ing to it.
* To reduce writes to the USB (increase longevity), avoid swap on the USB and consider fstrim or using ext4 mount options; or use a persistent overlay scheme for a live ISO if extreme endurance is a concern.

Quick checklist recap

1. Download & verify Arch ISO.
2. Create raw image or identify USB device.
3. Boot Arch ISO in VM (attach image or USB).
4. Partition (EFI + root), format, mount.
5. `pacstrap` base system; `genfstab`; `arch-chroot`.
6. Configure locale/time, create user, enable NetworkManager.
7. Install bootloader (systemd-boot recommended for UEFI), create loader entry with root UUID.
8. Exit, unmount; if using image, `dd` image to physical USB.
9. Boot the USB in VM (QEMU/VirtualBox) to finish installing packages and test.

If you want, I can:

* produce a small install script you can run inside the Arch live environment (I’ll assume a partition layout & device name you choose),
* or give the exact `qemu-system` / `VBoxManage` commands for your host OS (Linux/macOS/Windows) — tell me which host and which VM tool you prefer.
