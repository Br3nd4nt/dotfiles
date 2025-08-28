#!/bin/bash

# Neovim Setup Script
# This script helps manage Neovim dependencies and configuration

set -e

echo "🔧 Neovim Setup Script"
echo "======================"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Install/Update LuaRocks
echo "📦 Installing/Updating LuaRocks..."
brew install luarocks

# Configure LuaRocks to use the correct Lua version
echo "⚙️  Configuring LuaRocks..."
luarocks config lua_version 5.4

# Check Lua version
echo "🐍 Checking Lua version..."
lua -v

# Check LuaRocks configuration
echo "📋 LuaRocks configuration:"
luarocks config

# Sync Neovim plugins
echo "🔄 Syncing Neovim plugins..."
nvim --headless -c "Lazy sync" -c "qa"

echo "✅ Setup completed successfully!"
echo ""
echo "You can now start Neovim with: nvim"
echo "To check health: nvim --headless -c 'checkhealth' -c 'qa'"
echo "To sync plugins: nvim --headless -c 'Lazy sync' -c 'qa'"
