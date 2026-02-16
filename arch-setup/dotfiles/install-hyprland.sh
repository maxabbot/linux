#!/bin/bash
# ============================================================================
# Install Hyprland Configuration
# ============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }

backup_file() {
    if [ -e "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$1" "$BACKUP_DIR/$(basename "$1")"
        log_info "Backed up $1"
    fi
}

main() {
    log_info "Installing Hyprland configuration..."
    
    mkdir -p "$HOME/.config/hypr" "$HOME/.config/waybar"
    backup_file "$HOME/.config/hypr/hyprland.conf"
    backup_file "$HOME/.config/waybar"
    
    cp "$DOTFILES_DIR/hyprland/hyprland.conf" "$HOME/.config/hypr/"
    cp "$DOTFILES_DIR/hyprland/waybar-config.json" "$HOME/.config/waybar/config"
    cp "$DOTFILES_DIR/hyprland/waybar-style.css" "$HOME/.config/waybar/style.css"
    
    log_success "Hyprland config installed"
    log_success "Waybar config installed"
    
    log_warning "IMPORTANT: Configure your monitors in ~/.config/hypr/hyprland.conf"
    log_info "Look for the 'Monitor configuration' section and uncomment/adjust as needed"
    log_info "Check current monitors with: hyprctl monitors"
    
    log_warning "Optional tweaks:"
    echo "  - Customize gaps/borders in general section"
    echo "  - Adjust keybindings (search 'bind =' in config)"
    echo "  - Configure Waybar modules in ~/.config/waybar/config"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
