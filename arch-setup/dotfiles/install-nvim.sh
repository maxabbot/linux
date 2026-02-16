#!/bin/bash
# ============================================================================
# Install Neovim Configuration
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
    log_info "Installing Neovim configuration..."
    
    if ! command -v nvim &> /dev/null; then
        log_error "Neovim is not installed. Install with: sudo pacman -S neovim"
        exit 1
    fi
    
    mkdir -p "$HOME/.config/nvim"
    backup_file "$HOME/.config/nvim"
    
    cp -r "$DOTFILES_DIR/nvim"/* "$HOME/.config/nvim/"
    log_success "Neovim config installed to ~/.config/nvim"
    
    log_info "Installing plugins on first launch..."
    timeout 60 nvim -c 'autocmd User LazyDone qa!' --noplugin 2>/dev/null || true
    
    log_success "Neovim setup complete!"
    log_warning "Important: Run this in Neovim to install language servers:"
    echo "  :Mason"
    log_info "Required language servers for full functionality:"
    echo "  - pyright (Python)"
    echo "  - rust-analyzer (Rust)"
    echo "  - tsserver (TypeScript/JavaScript)"
    echo "  - bashls (Bash)"
    echo "  - lua_ls (Lua)"
    log_info "Optional formatters/linters:"
    echo "  - black, isort, pylint (Python)"
    echo "  - prettier (JavaScript/TypeScript)"
    echo "  - rustfmt (Rust)"
    echo "  - stylua (Lua)"
    echo "  - shfmt, shellcheck (Bash)"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
