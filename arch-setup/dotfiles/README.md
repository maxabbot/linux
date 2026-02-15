# Dotfiles

This directory contains configuration files (dotfiles) for various applications and desktop environments.

## Contents

- **bash/** - Bash shell configuration
- **zsh/** - Zsh shell configuration with Oh-My-Zsh support
- **nvim/** - Neovim IDE-like configuration with LSP support
- **hyprland/** - Hyprland window manager configuration
- **sway/** - Sway window manager configuration

## Quick Start

### Shell Configurations

#### Zsh (Feature-Rich with Oh-My-Zsh)

**Prerequisites:**
```bash
# Install Zsh and Oh-My-Zsh
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**Installation:**
```bash
cp zsh/.zshrc ~/.zshrc
p10k configure  # Run this to set up Powerlevel10k theme
```

**Features:**
- Powerlevel10k theme with instant prompt
- Git, Docker, Python, Rust, Node.js integrations
- Autosuggestions and syntax highlighting
- Custom functions: `mkcd`, `extract`, `qfind`, `mkvenv`, `serve`, `sysup`
- Development aliases for git, docker, python, rust, npm/yarn

#### Bash (Feature-Rich Alternative)

**Installation:**
```bash
cp bash/.bashrc ~/.bashrc
source ~/.bashrc
```

**Features:**
- Colorful prompt with git branch indication
- Similar aliases and functions as Zsh config
- Works without additional dependencies

### Neovim Configuration

**Prerequisites:**
```bash
# Install Neovim (0.9.0+)
sudo pacman -S neovim

# Install language servers and tools
sudo pacman -S nodejs npm python-pip rust-analyzer
npm install -g typescript typescript-language-server bash-language-server
pip install pyright black isort pylint
```

**Installation:**
```bash
# Copy config
cp -r nvim ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

**First Launch:**
1. Neovim will automatically install lazy.nvim plugin manager
2. Plugins will be installed automatically (wait for it to finish)
3. Run `:Mason` to verify language servers are installed
4. Run `:checkhealth` to verify everything is working

**Features:**
- Modern IDE-like interface with LSP support
- Language support: Python, Rust, JavaScript/TypeScript, Bash, Lua
- Auto-completion with nvim-cmp
- Syntax highlighting with Treesitter
- File explorer (nvim-tree), fuzzy finder (Telescope)
- Git integration (Gitsigns, LazyGit)
- Catppuccin Mocha color scheme

**Key Mappings:**
- Leader key: `Space`
- File explorer: `Space + e`
- Find files: `Space + ff`
- Live grep: `Space + fg`
- LSP: `gd` (definition), `gr` (references), `K` (hover), `Space + ca` (code actions)
- See `lua/config/keymaps.lua` for complete list

### Hyprland Configuration

**Prerequisites:**
```bash
sudo pacman -S hyprland waybar wofi kitty grim slurp wl-clipboard cliphist brightnessctl playerctl
```

**Installation:**
```bash
# Copy Hyprland config
cp hyprland/hyprland.conf ~/.config/hypr/hyprland.conf

# Copy Waybar config
mkdir -p ~/.config/waybar
cp hyprland/waybar-config.json ~/.config/waybar/config
cp hyprland/waybar-style.css ~/.config/waybar/style.css
```

**Features:**
- Gaming optimizations (VRR, immediate mode, high performance)
- Multi-monitor support
- Catppuccin Mocha theme
- Waybar status bar integration
- Vim-style navigation (hjkl)
- 10 workspaces with keybindings

**Key Mappings:**
- Mod key: `Super` (Windows key)
- Terminal: `Super + Enter`
- Launcher: `Super + D`
- Move focus: `Super + h/j/k/l` or arrow keys
- Move windows: `Super + Shift + h/j/k/l`
- Resize: `Super + Ctrl + h/j/k/l`
- Workspaces: `Super + [1-0]`
- Screenshot: `Print`, `Shift + Print`, `Super + Print`
- Gaming mode toggle: `Super + G` (disables blur/animations)

### Sway Configuration

**Prerequisites:**
```bash
sudo pacman -S sway waybar wofi kitty grim slurp wl-clipboard cliphist brightnessctl playerctl swaylock
```

**Installation:**
```bash
# Copy Sway config
mkdir -p ~/.config/sway
cp sway/config ~/.config/sway/config

# Copy Waybar config
mkdir -p ~/.config/waybar
cp sway/waybar-config.json ~/.config/waybar/config
cp sway/waybar-style.css ~/.config/waybar/style.css
```

**Features:**
- Similar to Hyprland but uses Sway/i3 syntax
- Gaming optimizations (adaptive sync, low render time)
- Multi-monitor support
- Catppuccin Mocha theme
- Vim-style navigation

**Key Mappings:**
- Similar to Hyprland (see `sway/config` for details)
- Resize mode: `Super + R` (then use hjkl or arrows)

## Language-Specific Setup

### Python
```bash
# Install tools referenced in configs
pip install --user black isort pylint autopep8
```

### Rust
```bash
# Rust toolchain (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Node.js
```bash
# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
```

## Fonts

For best experience, install a Nerd Font:
```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

## Color Scheme

All configurations use the **Catppuccin Mocha** color scheme for consistency across:
- Terminal (bash/zsh prompt)
- Neovim
- Hyprland/Sway
- Waybar

## Customization

### Local Overrides

- **Zsh**: Create `~/.zshrc.local` for machine-specific settings
- **Bash**: Create `~/.bashrc.local` for machine-specific settings
- **Neovim**: Modify files in `~/.config/nvim/lua/` after copying
- **Hyprland/Sway**: Edit config files directly in `~/.config/`

### Monitor Configuration

Both Hyprland and Sway configs include commented examples for multi-monitor setups. Uncomment and adjust as needed.

### Waybar Customization

- Edit `~/.config/waybar/config` for module changes
- Edit `~/.config/waybar/style.css` for styling
- Timezone can be changed in the clock module

## Troubleshooting

### Zsh plugins not working
```bash
# Verify plugins are installed
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
# Re-run Oh-My-Zsh installer if needed
```

### Neovim LSP errors
```bash
# Check LSP servers are installed
:Mason
# Check health
:checkhealth
```

### Waybar not showing
```bash
# Check if waybar is running
pgrep waybar
# Restart waybar
killall waybar; waybar &
# Check logs
journalctl --user -u waybar
```

### Hyprland/Sway issues
```bash
# Check logs
journalctl --user -b -u hyprland
# or for Sway
journalctl --user -b -u sway
```

## Additional Resources

- [Oh-My-Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Sway Wiki](https://github.com/swaywm/sway/wiki)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki) staging area

Use these folders to store configuration files that match the packages installed by the scripts:

- `bash/` — login shell configuration.
- `zsh/` — zsh configuration.
- `sway/` — sway or swaylock configs.
- `hyprland/` — Hyprland layouts, Waybar configs, wallpapers.
- `nvim/` — Neovim configuration.

Add, remove, or rename directories as your workflow evolves. The structure is intentionally empty so you can version-control custom dotfiles alongside the setup scripts.
