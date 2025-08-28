# Neovim Configuration 🚀

## Overview
This Neovim configuration uses **Lazy.nvim** as the plugin manager, providing a modern and efficient way to manage plugins. It's designed for Neovim 0.11+ and includes comprehensive LSP support, syntax highlighting, and a beautiful UI.

## Features
- **Lazy.nvim**: Fast plugin manager with lazy loading
- **Catppuccin**: Beautiful color scheme with multiple variants
- **Telescope**: Fuzzy finder for files, grep, buffers, and help
- **NERDTree**: File explorer with project-aware navigation
- **LSP Support**: Full Language Server Protocol support for multiple languages
- **Mason**: LSP installer and manager with UI
- **Treesitter**: Enhanced syntax highlighting and indentation
- **Which Key**: Modern key binding helper with organized menus
- **Comment**: Easy commenting with smart line/block detection
- **Surround**: Surround text with brackets, quotes, and more
- **Indent Blankline**: Visual indentation guides with scope highlighting
- **Auto Pairs**: Automatic bracket and quote pairing
- **Git Signs**: Git status indicators in the gutter
- **Buffer Line**: Enhanced buffer management with tabs

## Key Bindings

### Leader Key
- `<Space>` - Show which-key menu with all available commands

### File Navigation & Search
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>fh` - Find help tags (Telescope)

### File Explorer
- `<leader>ee` - Toggle NERDTree
- `<leader>ef` - Find current file in NERDTree

### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>sv` - Split vertically
- `<leader>sh` - Split horizontally
- `<leader>se` - Equalize window sizes
- `<leader>sx` - Close current window

### Code Actions & LSP
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover information
- `<leader>ca` - Code actions
- `<leader>crn` - Rename symbol
- `<leader>cf` - Format document

### Diagnostics
- `<leader>ds` - Show diagnostics
- `<leader>dn` - Next diagnostic
- `<leader>dp` - Previous diagnostic

### General Commands
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>nh` - Clear search highlights

### Theme Management
- `<leader>tp` - Theme picker (interactive)
- `<leader>tq` - Quick theme switch
- `<leader>tl` - List all themes

### Commands
- `:HealthCheck` - Run custom health check
- `:TSInstallAll` - Install all Treesitter parsers
- `:TSUpdateAll` - Update all Treesitter parsers
- `:TSStatus` - Check Treesitter parser status
- `:LSPInstall` - Install all LSP servers
- `:MasonStatus` - Check Mason status and installed packages
- `:CleanInstall` - Clean and reinstall all plugins
- `:Lazy sync` - Sync all plugins
- `:Lazy log` - View plugin installation logs

### Theme Commands
- `:ThemePicker` - Open interactive theme picker with Telescope
- `:ThemeQuick` - Quick switch between popular themes
- `:ThemeList` - List all available themes on your system

## Which-Key Integration
This configuration uses the modern which-key spec format for organized keybinding menus:

- **Press `<Space>`** to see all available commands organized by category
- **Hierarchical menus** show related commands together
- **Descriptive labels** for each command
- **Visual indicators** for groups and separators
- **Scroll support** with `<C-d>` and `<C-u>`

## Plugin Management
Plugins are managed by Lazy.nvim and will be automatically installed on first startup.

## System Requirements
- **Neovim**: Version 0.11.0 or higher
- **macOS**: Homebrew for package management
- **Tree-sitter CLI**: Required for syntax highlighting (`brew install tree-sitter-cli`)
- **Git**: For plugin installation and updates

## First Time Setup
1. **Install dotfiles**: Run `./install --install` from the dotfiles directory
2. **Install tree-sitter CLI**: `brew install tree-sitter-cli` (if not already installed)
3. **Start Neovim**: Plugins will be automatically installed via Lazy.nvim
4. **Wait for installation**: Initial plugin setup may take a few minutes
5. **Install language support**:
   - `:TSInstallAll` - Install Treesitter parsers
   - `:LSPInstall` - Install LSP servers

**Note**: This configuration uses Lazy.nvim for plugin management. All plugins are installed automatically in `~/.local/share/nvim/lazy/`.

## Recent Improvements
- ✅ **Modern which-key spec** - Updated to latest API format
- ✅ **Enhanced health checks** - Robust error handling and diagnostics
- ✅ **Tree-sitter CLI support** - Proper CLI detection and installation
- ✅ **Improved LSP configuration** - Better error handling and server setup
- ✅ **Optimized plugin loading** - Faster startup and better performance

## Troubleshooting
If you encounter issues:

### Common Issues
1. **Check system health**: Run `:checkhealth` for system requirements
2. **Plugin sync**: Run `:Lazy sync` to reinstall plugins
3. **View logs**: Check `:Lazy log` for error messages
4. **Custom health check**: Run `:HealthCheck` for detailed diagnostics

### Treesitter Issues
- **Parsers not installing**: Run `:TSInstallAll` to install all parsers
- **CLI not found**: Install `tree-sitter-cli` via Homebrew: `brew install tree-sitter-cli`
- **Update parsers**: Run `:TSUpdateAll` to update existing parsers
- **Check status**: Run `:TSStatus` to see installed parsers

### LSP Issues
- **Servers not installing**: Run `:LSPInstall` to install all LSP servers
- **Mason errors**: Try restarting Neovim and running `:Lazy sync`
- **Check Mason**: Run `:MasonStatus` to see installed packages

### Plugin Issues
- **Persistent problems**: Run `:CleanInstall` to completely reinstall plugins
- **Which-key warnings**: These are usually informational and don't affect functionality
- **Keymap overlaps**: Normal behavior for hierarchical menus

## Customization
- Add new plugins in `lua/plugins.lua`
- Modify key bindings in `lua/core.lua`
- Change LSP settings in `lua/plugins.lua`
