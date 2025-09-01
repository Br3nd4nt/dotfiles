# Neovim Configuration

This directory contains the Neovim configuration for the dotfiles setup.

## Features

- **Plugin Manager**: Lazy.nvim for fast plugin loading
- **Theme**: Catppuccin colorscheme
- **LSP**: Mason for language server management
- **Fuzzy Finder**: Telescope for file navigation
- **Syntax Highlighting**: Treesitter
- **Git Integration**: Gitsigns
- **File Explorer**: NERDTree
- **Keymaps**: Organized keymaps for easy discovery

## Setup

### Prerequisites

- Neovim (latest version)
- Homebrew (for dependency management)
- Git

### Installation

1. **Run the setup script** (recommended):
   ```bash
   ./config/nvim/setup.sh
   ```

2. **Manual setup**:
   ```bash
   # Install LuaRocks
   brew install luarocks
   
   # Configure LuaRocks
   luarocks config lua_version 5.4
   
   # Sync plugins
   nvim --headless -c "Lazy sync" -c "qa"
   ```

## Troubleshooting

### LuaRocks/Lua 5.1 Warnings

If you see warnings about LuaRocks or Lua 5.1 not being installed:

1. **Solution 1** (Recommended): The configuration now disables LuaRocks by default. This is the safest approach.

2. **Solution 2**: If you need LuaRocks for specific plugins:
   ```bash
   brew install luarocks
   luarocks config lua_version 5.4
   ```

### Plugin Issues

- **Clean install**: `nvim --headless -c "Lazy clean" -c "Lazy sync" -c "qa"`
- **Check health**: `nvim --headless -c "checkhealth" -c "qa"`
- **Update plugins**: `nvim --headless -c "Lazy update" -c "qa"`

### LSP Issues

- **Install LSP servers**: `:LSPInstall` (in Neovim)
- **Check Mason status**: `:MasonStatus` (in Neovim)

## Keymaps

### Leader Key: `<Space>`

#### File Operations
- `ff` - Find files (Telescope)
- `fa` - Find all files (including hidden)
- `fw` - Live grep (Telescope)
- `fb` - Find buffers (Telescope)
- `fh` - Help tags (Telescope)
- `fo` - Find old files (Telescope)
- `fz` - Find in current buffer (Telescope)

#### Explorer & Windows
- `ee` - Toggle NERDTree
- `ef` - Focus NERDTree
- `sv` - Split vertically
- `sh` - Split horizontally
- `se` - Equalize windows
- `sx` - Close window

#### Basic Operations
- `w` - Save file
- `q` - Quit
- `nh` - Clear highlight

#### Code & LSP
- `ca` - Code action
- `cr` - Rename
- `cf` - Format
- `gd` - Go to definition
- `K` - Hover documentation

#### Diagnostics
- `ds` - Show diagnostics
- `dn` - Next diagnostic
- `dp` - Previous diagnostic

#### Git
- `cm` - Git commits (Telescope)
- `gt` - Git status (Telescope)



### LSP Keymaps

- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation

### Window Navigation

- `<C-h/j/k/l>` - Navigate between windows

## Custom Commands

- `:TSInstallAll` - Install all treesitter parsers
- `:TSUpdateAll` - Update all treesitter parsers
- `:TSStatus` - Check treesitter status
- `:LSPInstall` - Install LSP servers
- `:MasonStatus` - Check Mason status
- `:CleanInstall` - Clean and reinstall plugins


## Configuration Files

- `init.lua` - Main entry point
- `lua/core/` - Core configuration modules
  - `lua/core.lua` - Core Neovim settings and autocommands
  - `lua/core/utils.lua` - Utility functions for loading mappings and config
  - `lua/core/mappings.lua` - All keymap definitions organized by plugin
  - `lua/core/default_config.lua` - Default configuration settings
  - `lua/core/highlights.lua` - Color scheme overrides
- `lua/plugins.lua` - Plugin configurations with lazy loading
- `lua/health.lua` - Health check utilities

## Dependencies

- **LuaRocks**: Disabled by default to avoid installation issues
- **Lua**: 5.4+ (system default)
- **Homebrew**: For package management

## Recent Improvements

- ✅ **Centralized mappings**: All keymaps managed through core.mappings module
- ✅ **Eliminated conflicts**: Removed duplicate keymap registrations that caused overlapping warnings
- ✅ **LuaRocks disabled**: Prevents installation issues and warnings
- ✅ **Clean health checks**: No more overlapping keymap warnings
- ✅ **Performance optimized**: Only loads plugins when needed
- ✅ **Better organization**: Separated mappings, utils, and config into modules
- ✅ **NvChad-style structure**: Using proven patterns for plugin management

## Notes

- LuaRocks is disabled by default to prevent installation issues
- All plugins are managed through Lazy.nvim with lazy loading
- LSP servers are managed through Mason
- Treesitter parsers are installed on-demand
- Keymaps are centralized in core.mappings module and loaded by plugins
- All plugins only load when their specific keys/commands are triggered
- Configuration follows NvChad-style modular structure for better organization
