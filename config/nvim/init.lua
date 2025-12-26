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

-- Key Mappings
-- require("keymappings").setup()


local keymap = vim.keymap.set

-- Delete without yanking (black hole register)
keymap("n", "d", '"_d', { noremap = true })
keymap("n", "x", '"_x', { noremap = true })
keymap("v", "d", '"_d', { noremap = true })

-- Optional: keep change from polluting clipboard
keymap("n", "c", '"_c', { noremap = true })
keymap("v", "c", '"_c', { noremap = true })

