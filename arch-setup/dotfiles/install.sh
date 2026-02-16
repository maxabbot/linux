#!/bin/bash
# ============================================================================
# Dotfiles Installation Script
# Automatically installs and configures dotfiles for shells, editors, and DEs
# ============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

backup_file() {
    if [ -e "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$1" "$BACKUP_DIR/$(basename "$1")"
        log_info "Backed up $1 to $BACKUP_DIR"
    fi
}

install_zsh() {
    log_info "Installing Zsh configuration..."
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed. Install with: sudo pacman -S zsh"
        return 1
    fi
    
    backup_file "$HOME/.zshrc"
    
    cp "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    log_success "Zsh config installed"
    
    # Check for Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh-My-Zsh not installed. Install with:"
        echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
        return 1
    fi
    
    # Check for Powerlevel10k
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log_warning "Powerlevel10k not installed. Install with:"
        echo "  git clone --depth=1 https://github.com/romkatov/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        return 1
    fi
    
    log_success "Zsh setup complete!"
}

install_bash() {
    log_info "Installing Bash configuration..."
    
    backup_file "$HOME/.bashrc"
    
    cp "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    log_success "Bash config installed"
}

install_nvim() {
    log_info "Installing Neovim configuration..."
    
    if ! command -v nvim &> /dev/null; then
        log_error "Neovim is not installed. Install with: sudo pacman -S neovim"
        return 1
    fi
    
    mkdir -p "$HOME/.config/nvim"
    backup_file "$HOME/.config/nvim"
    
    cp -r "$DOTFILES_DIR/nvim"/* "$HOME/.config/nvim/"
    log_success "Neovim config installed"
    
    log_info "Launching Neovim to auto-install plugins..."
    log_info "This may take a minute on first launch..."
    
    # Auto-install plugins by opening and closing nvim
    timeout 30 nvim -c 'autocmd User LazyDone qa!' --noplugin 2>/dev/null || true
    
    log_info "Neovim setup complete! Run ':Mason' in Neovim to install language servers"
}

install_hyprland() {
    log_info "Installing Hyprland configuration..."
    
    mkdir -p "$HOME/.config/hypr" "$HOME/.config/waybar"
    backup_file "$HOME/.config/hypr/hyprland.conf"
    backup_file "$HOME/.config/waybar"
    
    cp "$DOTFILES_DIR/hyprland/hyprland.conf" "$HOME/.config/hypr/"
    cp "$DOTFILES_DIR/hyprland/waybar-config.json" "$HOME/.config/waybar/config"
    cp "$DOTFILES_DIR/hyprland/waybar-style.css" "$HOME/.config/waybar/style.css"
    
    log_success "Hyprland config installed"
    log_warning "Edit ~/.config/hypr/hyprland.conf to configure your monitors"
}

install_sway() {
    log_info "Installing Sway configuration..."
    
    mkdir -p "$HOME/.config/sway" "$HOME/.config/waybar"
    backup_file "$HOME/.config/sway/config"
    backup_file "$HOME/.config/waybar"
    
    cp "$DOTFILES_DIR/sway/config" "$HOME/.config/sway/"
    cp "$DOTFILES_DIR/sway/waybar-config.json" "$HOME/.config/waybar/config"
    cp "$DOTFILES_DIR/sway/waybar-style.css" "$HOME/.config/waybar/style.css"
    
    log_success "Sway config installed"
    log_warning "Edit ~/.config/sway/config to configure your monitors"
}

show_menu() {
    echo ""
    echo "===== Dotfiles Installation Menu ====="
    echo ""
    echo "1) Install Bash configuration"
    echo "2) Install Zsh configuration (requires Oh-My-Zsh)"
    echo "3) Install Neovim configuration"
    echo "4) Install Hyprland configuration"
    echo "5) Install Sway configuration"
    echo ""
    echo "6) Install all (Bash + Nvim + Hyprland)"
    echo "7) Install all (Bash + Nvim + Sway)"
    echo ""
    echo "0) Exit"
    echo ""
}

main() {
    log_info "Dotfiles Installation Script"
    
    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi
    
    while true; do
        show_menu
        read -p "Select an option [0-7]: " choice
        
        case $choice in
            1) install_bash ;;
            2) install_zsh ;;
            3) install_nvim ;;
            4) install_hyprland ;;
            5) install_sway ;;
            6) install_bash && install_nvim && install_hyprland ;;
            7) install_bash && install_nvim && install_sway ;;
            0) log_info "Exiting"; exit 0 ;;
            *) log_error "Invalid option. Please try again." ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
