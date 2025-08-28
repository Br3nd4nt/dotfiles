-- =============================================================================
-- Plugins Configuration (Git Submodules)
-- =============================================================================

-- Add plugin paths to runtimepath
local plugin_path = vim.fn.stdpath("config") .. "/pack/plugins/start"

-- Load plugins from submodules
vim.opt.rtp:prepend(plugin_path)

-- Plugin-specific configurations
local function setup_plugins()
  -- Catppuccin colorscheme
  vim.cmd.colorscheme "catppuccin"
  
  -- Telescope configuration
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    },
  })
  
  -- Load telescope extensions if available
  pcall(function()
    telescope.load_extension("fzf")
  end)
end

-- Setup plugins after VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  callback = setup_plugins,
})
