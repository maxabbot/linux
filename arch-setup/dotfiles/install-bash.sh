#!/bin/bash
# ============================================================================
# Install Bash Configuration
# ============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

backup_file() {
    if [ -e "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$1" "$BACKUP_DIR/$(basename "$1")"
        log_info "Backed up $1"
    fi
}

main() {
    log_info "Installing Bash configuration..."
    
    backup_file "$HOME/.bashrc"
    cp "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    log_success "Bash config installed to ~/.bashrc"
    
    log_info "Restart your terminal or run 'source ~/.bashrc' to apply changes"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
