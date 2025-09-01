#!/bin/bash

# =============================================================================
# Ansible Installation Script
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

# Function to install Ansible on Fedora
install_on_fedora() {
    print_status "Installing Ansible on Fedora..."
    sudo dnf install -y ansible
    print_success "Ansible installed successfully on Fedora"
}

# Function to install Ansible on Ubuntu
install_on_ubuntu() {
    print_status "Installing Ansible on Ubuntu..."
    sudo apt-get update
    sudo apt-get install -y ansible
    print_success "Ansible installed successfully on Ubuntu"
}

# Function to install Ansible on macOS
install_on_mac() {
    print_status "Installing Ansible on macOS..."
    brew install ansible
    print_success "Ansible installed successfully on macOS"
}

print_status "Detecting operating system and installing Ansible..."

# Detect operating system
OS="$(uname -s)"

case "${OS}" in
    Linux*)
        if [ -f /etc/fedora-release ]; then
            install_on_fedora
        elif [ -f /etc/lsb-release ]; then
            install_on_ubuntu
        else
            print_error "Unsupported Linux distribution"
            print_status "Please install Ansible manually for your distribution"
            exit 1
        fi
        ;;
    Darwin*)
        install_on_mac
        ;;
    *)
        print_error "Unsupported operating system: ${OS}"
        print_status "Please install Ansible manually for your operating system"
        exit 1
        ;;
esac

print_success "Ansible installation completed!"
print_status "You can now run: ansible-playbook playbooks/main.yml"
