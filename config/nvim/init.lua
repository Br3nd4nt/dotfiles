-- =============================================================================
-- Neovim Configuration with Git Submodules
-- =============================================================================

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("core")

-- Load plugins from git submodules
require("plugins_main_loader")
