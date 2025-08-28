-- =============================================================================
-- Plugins Configuration with Lazy.nvim
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- All plugins have lazy=true by default, to load a plugin on startup just lazy=false
local default_plugins = {
  "nvim-lua/plenary.nvim",

  -- Disable LuaRocks to avoid installation issues
  rocks = {
    enabled = false,
  },
  -- Catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          aerial = true,
          alpha = true,
          cmp = true,
          gitsigns = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          notify = true,
          neotree = true,
          treesitter = true,
          which_key = true,
        },
        color_overrides = {},
        custom_highlights = {},
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  

  
  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    config = function()
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
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
      })
      
      -- Load builtin pickers
      require("telescope.builtin")
    end,
  },
  
  -- NERDTree
  {
    "preservim/nerdtree",
    cmd = { "NERDTreeToggle", "NERDTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeIgnore = { ".git", "node_modules", ".cache" }
    end,
  },
  
  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  
  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  
  -- Mini Icons (required by which-key)
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      triggers = { "auto" },
      win = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        relative = "editor",
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      show_help = true,
      show_keys = true,
      replace = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
        ["<esc>"] = "ESC",
        ["<bs>"] = "BS",
        ["<leader>"] = "LEADER",
      },
    },
  },
  
  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
      })
    end,
  },
  
  -- Mason LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "jsonls",
          "yamlls",
          "bashls",
          "dockerls",
          "marksman",
        },
        automatic_installation = false, -- Disable automatic installation to avoid errors
      })
    end,
  },
  
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      require("core.utils").load_mappings "lspconfig"
    end,
    config = function()
      local lspconfig = require("lspconfig")
      
      -- LSP servers configuration
      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        
        -- JSON
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },
        
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
              },
            },
          },
        },
        
        -- Bash
        bashls = {
          settings = {
            bash = {
              validate = true,
            },
          },
        },
        
        -- Docker
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignore = {},
                },
              },
            },
          },
        },
        
        -- Markdown
        marksman = {},
      }
      
      -- Setup each server with error handling
      for server_name, config in pairs(servers) do
        pcall(function()
          lspconfig[server_name].setup(config)
        end)
      end
    end,
  },
  
  -- LSP keymaps
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup()
    end,
  },
  
  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "python",
          "json",
          "yaml",
          "bash",
          "dockerfile",
          "markdown",
          "vim",
          "c",
          "cpp",
        },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = false, -- Disable auto-install to avoid startup issues
        sync_install = false, -- Don't sync install during startup
      })
    end,
  },
  
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  
  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          show_buffer_close_icons = true,
          show_close_icon = false,
        },
      })
    end,
  },
  
  -- Indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          injected_languages = true,
          highlight = "Function",
          priority = 500,
        },
      })
    end,
  },
}

local config = require("core.utils").load_config()

require("lazy").setup(default_plugins, config.lazy_nvim)
