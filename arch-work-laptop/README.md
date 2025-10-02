# Arch Linux Work Laptop Setup

This folder contains setup scripts for configuring an Arch Linux work laptop focused on data/software engineering development with standard productivity applications.

## Prerequisites

- Fresh Arch Linux installation
- Internet connection
- User account with sudo privileges

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
```

## Notes

- Scripts use `--noconfirm` flag to avoid interactive prompts
- You may need to log out and back in after running the development tools script for Docker group changes to take effect
- Some AUR packages may take time to build
- Customize the scripts to add or remove packages based on your needs

## Post-Installation

After running all scripts:
1. Configure Git with your credentials: `git config --global user.name "Your Name"` and `git config --global user.email "your.email@example.com"`
2. Set up SSH keys for GitHub/GitLab
3. Configure your IDE preferences
4. Set up database passwords and configurations
5. Sign in to cloud storage services
6. Configure browser sync and extensions

## Troubleshooting

If you encounter issues:
- Check internet connection
- Ensure sufficient disk space
- Review error messages for specific package failures
- Some AUR packages may require manual intervention
- Consult Arch Wiki for specific package issues
