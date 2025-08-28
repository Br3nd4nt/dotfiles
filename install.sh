#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if file/directory exists
check_exists() {
    local target="$1"
    if [ -f "$target" ] || [ -d "$target" ]; then
        print_warning "Will backup: $target -> $target.backup"
        return 0
    else
        print_success "Will create: $target"
        return 1
    fi
}

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Dotfiles installation preview from: $DOTFILES_DIR"
print_status "This script will show what would be installed."
print_status "To actually install, run: ./install.sh --install"
echo

# Check if --install flag is provided
if [[ "$1" != "--install" ]]; then
    print_status "=== PREVIEW MODE ==="
    print_status "The following symlinks would be created:"
    echo
    
    # Main dotfiles
    print_status "Main dotfiles:"
    check_exists "$HOME/.zshrc"
    check_exists "$HOME/.zprofile"
    check_exists "$HOME/.gitconfig"
    check_exists "$HOME/.gitignore_global"
    echo
    
    # Config directories
    print_status "Configuration directories:"
    check_exists "$HOME/.config/nvim"
    check_exists "$HOME/.config/ohmyposh"
    check_exists "$HOME/.config/fzf-git.sh"
    echo
    
    print_status "To install, run: ./install.sh --install"
    exit 0
fi

print_status "=== INSTALLATION MODE ==="

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        print_warning "Symlink already exists: $target"
        return 0
    fi
    
    if [ -f "$target" ] || [ -d "$target" ]; then
        print_warning "Backing up existing file/directory: $target"
        mv "$target" "$target.backup"
    fi
    
    ln -sf "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p ~/.config
mkdir -p ~/.local/bin

# Install main dotfiles
print_status "Installing main dotfiles..."

# ZSH configuration
create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"

# Git configuration
create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"

# Install config directories
print_status "Installing configuration directories..."

# Neovim
if [ -d "$DOTFILES_DIR/config/nvim" ]; then
    create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
fi

# Oh My Posh
if [ -d "$DOTFILES_DIR/config/ohmyposh" ]; then
    create_symlink "$DOTFILES_DIR/config/ohmyposh" "$HOME/.config/ohmyposh"
fi

# FZF Git
if [ -d "$DOTFILES_DIR/config/fzf-git.sh" ]; then
    create_symlink "$DOTFILES_DIR/config/fzf-git.sh" "$HOME/.config/fzf-git.sh"
fi

print_success "Dotfiles installation completed!"
print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
