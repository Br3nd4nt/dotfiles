-- =============================================================================
-- Neovim Configuration with Git Submodules
-- =============================================================================

-- Load core configuration
require("core")

-- Load plugins from git submodules
require("plugins_main_loader")
require("keymappings").setup()
