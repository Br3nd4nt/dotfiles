local M = {}

-- Default configuration for lazy.nvim
M.lazy_nvim = {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

return M
