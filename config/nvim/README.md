# Neovim Configuration 🚀

## Overview
This Neovim configuration uses **Lazy.nvim** as the plugin manager, providing a modern and efficient way to manage plugins.

## Features
- **Lazy.nvim**: Fast plugin manager with lazy loading
- **Catppuccin**: Beautiful color scheme
- **Telescope**: Fuzzy finder for files, grep, and more
- **NERDTree**: File explorer
- **LSP Support**: Language Server Protocol for multiple languages
- **Mason**: LSP installer and manager
- **Treesitter**: Enhanced syntax highlighting
- **Which Key**: Key binding helper
- **Comment**: Easy commenting
- **Surround**: Surround text with brackets, quotes, etc.

## Key Bindings

### General
- `<Space>` - Leader key
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>nh` - Clear search highlights

### File Navigation
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>e` - Toggle NERDTree
- `<leader>ef` - Find current file in NERDTree

### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>sv` - Split vertically
- `<leader>sh` - Split horizontally
- `<leader>se` - Equalize window sizes
- `<leader>sx` - Close current window

### LSP (Language Server Protocol)
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover information
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document
- `<leader>ds` - Show diagnostics
- `<leader>dn` - Next diagnostic
- `<leader>dp` - Previous diagnostic

### Commands
- `:HealthCheck` - Run custom health check
- `:TSInstallAll` - Install all Treesitter parsers
- `:LSPInstall` - Install all LSP servers
- `:MasonStatus` - Check Mason status and installed packages
- `:CleanInstall` - Clean and reinstall all plugins
- `:Lazy sync` - Sync all plugins
- `:Lazy log` - View plugin installation logs

## Plugin Management
Plugins are managed by Lazy.nvim and will be automatically installed on first startup.

## First Time Setup
1. Install the dotfiles using `./install --install`
2. Start Neovim - plugins will be automatically installed via Lazy.nvim
3. Wait for the initial plugin installation to complete
4. If needed, manually install parsers and LSP servers:
   - `:TSInstallAll` - for Treesitter parsers
   - `:LSPInstall` - for LSP servers

**Note**: This configuration uses Lazy.nvim instead of git submodules. All plugins are managed automatically and will be installed in `~/.local/share/nvim/lazy/`.

## Troubleshooting
If you encounter issues:
1. Check `:checkhealth` for system requirements
2. Run `:Lazy sync` to reinstall plugins
3. Check `:Lazy log` for error messages
4. Run `:HealthCheck` for custom health check
5. If Treesitter parsers fail to install, run `:TSInstallAll`
6. If LSP servers fail to install, run `:LSPInstall`
7. For Mason errors, try restarting Neovim and running `:Lazy sync`
8. For persistent issues, run `:CleanInstall` to completely reinstall plugins

## Customization
- Add new plugins in `lua/plugins.lua`
- Modify key bindings in `lua/core.lua`
- Change LSP settings in `lua/plugins.lua`
