# linux-setup-scripts
Collection of setup scripts for linux distros

## Available Setups

### [Arch Linux - Work Laptop](arch-work-laptop/)
Setup scripts for an Arch Linux work laptop focused on data/software engineering development with standard productivity applications.

**Features:**
- Development tools (Python, Node.js, Go, Rust, Java, C/C++)
- Data science & analytics (NumPy, Pandas, TensorFlow, PyTorch, Jupyter)
- Databases (PostgreSQL, MariaDB, Redis, SQLite)
- Container tools (Docker, Kubernetes)
- IDEs (VS Code, PyCharm, IntelliJ IDEA)
- Productivity apps (LibreOffice, browsers, communication tools)
- Cloud storage (Dropbox, Google Drive)
- Image editing (GIMP, Inkscape)

### [Arch Linux - Home Desktop](arch-home-desktop/)
Setup scripts for an Arch Linux home desktop PC with development tools, productivity applications, gaming support, and NVIDIA RTX 4070 drivers.

**Features:**
- All features from the work laptop setup
- **Gaming:** Steam with Proton, Lutris, Heroic Games Launcher
- **Game streaming:** Moonlight-Qt (Apollo streaming)
- **Game optimization:** GameMode, MangoHud, GOverlay
- **NVIDIA support:** RTX 4070 drivers, CUDA, Vulkan, OpenCL
- **Windows apps:** Wine, Bottles

## Quick Start

1. Clone this repository
2. Navigate to the desired setup folder
3. Follow the README instructions in that folder
4. Run the scripts in order

```bash
git clone https://github.com/maxabbot/linux-setup-scripts.git
cd linux-setup-scripts

# For work laptop
cd arch-work-laptop
chmod +x *.sh
./01-base-system.sh
./02-development-tools.sh
./03-productivity-apps.sh

# For home desktop
cd arch-home-desktop
chmod +x *.sh
./01-base-system.sh
./02-development-tools.sh
./03-productivity-apps.sh
./04-nvidia-drivers.sh
./05-gaming.sh
```

## Notes

- Scripts are designed for fresh Arch Linux installations
- Internet connection required
- Some scripts require sudo privileges
- Reboot may be required after certain installations (especially NVIDIA drivers)
- AUR packages may take time to build

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License - see [LICENSE](LICENSE) file for details
