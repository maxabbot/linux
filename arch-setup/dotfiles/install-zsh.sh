#!/bin/bash
# ============================================================================
# Install Zsh Configuration
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
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

backup_file() {
    if [ -e "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$1" "$BACKUP_DIR/$(basename "$1")"
        log_info "Backed up $1"
    fi
}

main() {
    log_info "Installing Zsh configuration..."
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed. Install with: sudo pacman -S zsh"
        exit 1
    fi
    
    backup_file "$HOME/.zshrc"
    cp "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    log_success "Zsh config installed to ~/.zshrc"
    
    # Verify Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh-My-Zsh not found. Installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Verify Powerlevel10k theme
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log_warning "Powerlevel10k theme not found. Installing..."
        git clone --depth=1 https://github.com/romkatov/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
    
    # Verify plugins
    PLUGINS_NEEDED=("zsh-autosuggestions" "zsh-syntax-highlighting")
    for plugin in "${PLUGINS_NEEDED[@]}"; do
        if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin" ]; then
            log_warning "Installing $plugin..."
            case "$plugin" in
                zsh-autosuggestions)
                    git clone https://github.com/zsh-users/zsh-autosuggestions \
                        "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
                    ;;
                zsh-syntax-highlighting)
                    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
                        "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
                    ;;
            esac
        fi
    done
    
    chsh -s /usr/bin/zsh
    log_success "Zsh set as default shell"
    
    log_success "Zsh installation complete!"
    log_info "Run 'p10k configure' to customize Powerlevel10k theme"
    log_info "Restart your terminal or run 'zsh' to apply changes"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
