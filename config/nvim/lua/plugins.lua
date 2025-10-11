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

  -- TokyoNight colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Load on startup
    priority = 1000, -- High priority to ensure it loads early
    opts = {},
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- Do not set a colorscheme here; we restore the user's last choice if present
    end,
  },

{ "nvim-neotest/nvim-nio" },

  -- vim-airline status line
  {
    "vim-airline/vim-airline",
    lazy = false, -- Load on startup
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
    config = function()
      -- Function to detect if current colorscheme is light or dark
      local function is_light_colorscheme()
        local colors_name = vim.g.colors_name or ""

        -- Common light colorschemes
        local light_patterns = {
          "day", "light", "latte", "dawn", "rose-pine-dawn", "catppuccin_latte",
          "PaperColor", "github", "gruvbox_light", "solarized8_light"
        }

        for _, pattern in ipairs(light_patterns) do
          if colors_name:lower():match(pattern:lower()) then
            return true
          end
        end

        -- Check background setting
        if vim.o.background == "light" then
          return true
        end

        return false
      end

      -- Function to update airline theme based on light/dark detection
      local function update_airline_theme()
        if not vim.g.loaded_airline then
          return
        end

        local is_light = is_light_colorscheme()
        local airline_theme = is_light and "light" or "dark"

        -- Set airline theme
        vim.g.airline_theme = airline_theme

        -- Refresh airline
        pcall(function()
          vim.cmd("AirlineRefresh")
        end)
      end

      -- Set initial airline configuration
      vim.g.airline_theme = "dark" -- default
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_showmode = 1
      vim.g.airline_showpaste = 1
      vim.g.airline_showcmd = 1
      vim.g.airline_showtabline = 1

      -- Auto-update airline when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Small delay to ensure colorscheme is fully loaded
          vim.defer_fn(update_airline_theme, 100)
        end,
      })

      -- Initial update
      vim.defer_fn(update_airline_theme, 100)
    end,
  },



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
      -- Load telescope mappings when telescope is needed
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

  -- Colorscheme preview and management
  {
    "zaldih/themery.nvim",
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = {}, -- Will be populated automatically
        livePreview = true,
        themeConfigFile = "~/.config/nvim/lua/colorscheme.lua",
        livePreviewBufName = "THEMERY_PREVIEW",
        defaultBackground = "dark",
        sort = "name",
        preview = {
          keymap = {
            n = {
              ["<CR>"] = "apply_theme",
              ["<C-c>"] = "close_preview",
              ["<C-s>"] = "save_theme",
            },
          },
        },
      })
    end,
  },

  -- nvim-tree
{
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Иконки
  },
  init = function()
    require("core.utils").load_mappings "nvimtree"
    vim.api.nvim_set_keymap("n", "<F6>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
  end,
  config = function()
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 35,
        side = "left",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          glyphs = {
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { ".git", "node_modules", ".cache" },
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 200,
      },
    })
  end,
},


  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    lazy = false,
    init = function()
      require("core.utils").load_mappings "toggleterm"
      vim.api.nvim_set_keymap('n', '<F5>', ':ToggleTerm direction=float<CR>', { noremap = true, silent = true })
    end,
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<F5>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        -- Fix modifiable issues
        on_create = function(term)
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.signcolumn = "no"
          -- Ensure buffer is modifiable
          vim.api.nvim_buf_set_option(term.bufnr, "modifiable", true)
          vim.api.nvim_buf_set_option(term.bufnr, "readonly", false)
        end,
        on_open = function(term)
          -- Ensure we can edit in terminal
          vim.api.nvim_buf_set_option(term.bufnr, "modifiable", true)
          vim.cmd("startinsert!")
        end,
      })
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
          "clangd",        -- C/C++ LSP
        },
        automatic_installation = false, -- Disable automatic installation to avoid errors
      })
    end,
  },

  -- LSP config
{
  "j-hui/fidget.nvim",
  tag = "legacy",
  lazy=false,
  config = function()
    require("fidget").setup({})
  end,
},

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    lazy=false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      require("core.utils").load_mappings "lspconfig"
    end,
    config = function()
      local lspconfig = vim.lsp.config

      -- Setup completion capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
      pythonPath = vim.fn.getcwd() .. "/.venv/bin/python", -- uv's default venv
      analysis = {
        typeCheckingMode = "basic", -- or "strict"
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
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

        -- C/C++
        clangd = {
          cmd = { "clangd", "--background-index" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          settings = {
            clangd = {
              InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
              },
              fallbackFlags = { "-std=c17" },
            },
          },
        },

        -- Swift
        sourcekit = {
          cmd = { "/opt/homebrew/opt/swift/bin/sourcekit-lsp" },
          filetypes = { "swift" },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern('Package.swift', '.git')(fname)
                or vim.fn.getcwd()
          end,
          settings = {},
          init_options = {},
          capabilities = capabilities,
        },
      }

      -- Setup each server with error handling
      for server_name, config in pairs(servers) do
        pcall(function()
          -- Add capabilities to each server config
          config.capabilities = capabilities
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
          "swift",
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
    lazy=false,
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup()

      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },



  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      require("luasnip").setup()
    end,
  },



  -- VSCode-like inline completion
  {
    "stevearc/dressing.nvim",
    lazy=false,
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          win_options = {
            winblend = 0,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf", "builtin" },
          builtin = {
            win_options = {
              winblend = 0,
            },
          },
        },
      })
    end,
  },

{
  "linux-cultist/venv-selector.nvim",
  lazy=false,
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
  config = function()
    require("venv-selector").setup({
      settings = {
        search = {
          venvs = { ".venv" }, -- uv default
        },
      },
    })
  end,
},

{
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.mypy,
      },
    })
  end,
},


  -- Enhanced completion with better UI
  {
    "onsails/lspkind.nvim",
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "󰆧",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "󰜢",
          Module = "󰏗",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "󰒻",
          Keyword = "󰌋",
          Snippet = "󰆐",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "󰒻",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "󰆧",
          Operator = "󰆕",
          TypeParameter = "󰊄",
        },
      })
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup({
        -- Enable color icons
        color_icons = true,
        -- Enable default icons for unknown file types
        default = true,
        -- Enable strict mode (only return icons for known file types)
        strict = false,
        -- Custom icons for specific file types
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          },
          vim = {
            icon = "",
            color = "#019833",
            cterm_color = "28",
            name = "Vim"
          },
          lua = {
            icon = "",
            color = "#51a0cf",
            cterm_color = "74",
            name = "Lua"
          },
          py = {
            icon = "",
            color = "#ffbc03",
            cterm_color = "214",
            name = "Python"
          },
          swift = {
            icon = "",
            color = "#e37933",
            cterm_color = "166",
            name = "Swift"
          },
          c = {
            icon = "",
            color = "#599eff",
            cterm_color = "75",
            name = "C"
          },
          cpp = {
            icon = "",
            color = "#f34b7d",
            cterm_color = "204",
            name = "CPlusPlus"
          },
          sh = {
            icon = "",
            color = "#4d5a5e",
            cterm_color = "240",
            name = "Shell"
          },
          bash = {
            icon = "",
            color = "#4d5a5e",
            cterm_color = "240",
            name = "Bash"
          },
        },
        -- Override by filename
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#e24329",
            name = "GitIgnore"
          },
          ["README.md"] = {
            icon = "",
            color = "#519aba",
            name = "Readme"
          },
          ["LICENSE"] = {
            icon = "",
            color = "#d0bf41",
            name = "License"
          },
        },
      })
    end,
  },

  -- Completion framework
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
      "hrsh7th/cmp-buffer",       -- Buffer completion source
      "hrsh7th/cmp-path",         -- Path completion source
      "hrsh7th/cmp-cmdline",      -- Command line completion source
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet completion source
      "rafamadriz/friendly-snippets", -- Collection of snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        enabled = function()
          -- Disable completion in comments and prompts
          local context = require 'cmp.config.context'
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
          end
        end,
        preselect = cmp.PreselectMode.Item,
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },    -- LSP completions (highest priority)
          { name = "luasnip" },     -- Snippet completions
        }, {
          { name = "buffer" },      -- Buffer completions (lower priority)
          { name = "path" },        -- Path completions
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Enhanced icons for completion item kinds
            local icons = {
              Text = "󰉿",          -- Text
              Method = "󰆧",         -- Method
              Function = "󰊕",       -- Function
              Constructor = "",    -- Constructor
              Field = "󰜢",          -- Field
              Variable = "󰀫",       -- Variable
              Class = "󰠱",          -- Class
              Interface = "",      -- Interface
              Module = "",         -- Module
              Property = "󰜢",       -- Property
              Unit = "󰑭",           -- Unit
              Value = "󰎠",          -- Value
              Enum = "",           -- Enum
              Keyword = "󰌋",        -- Keyword
              Snippet = "",        -- Snippet
              Color = "󰏘",          -- Color
              File = "󰈙",           -- File
              Reference = "󰈇",      -- Reference
              Folder = "󰉋",         -- Folder
              EnumMember = "",     -- EnumMember
              Constant = "󰏿",       -- Constant
              Struct = "󰙅",         -- Struct
              Event = "",          -- Event
              Operator = "󰆕",       -- Operator
              TypeParameter = "", -- TypeParameter
            }

            -- Get icon from devicons for file-based completions
            local icon, hl_group
            if vim_item.kind == "File" then
              icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind_hl_group = hl_group
                vim_item.kind = icon
              else
                vim_item.kind = icons[vim_item.kind] or ""
              end
            else
              vim_item.kind = icons[vim_item.kind] or ""
            end

            -- Enhanced menu labels with colors
            local menu_items = {
              nvim_lsp = "[LSP]",
              luasnip = "[󰩫 Snippet]",
              buffer = "[󰯂 Buffer]",
              path = "[󰝰 Path]",
              cmdline = "[󰞷 CMD]",
            }

            vim_item.menu = menu_items[entry.source.name] or string.format("[%s]", entry.source.name)

            -- Truncate long items
            local label = vim_item.abbr
            local truncated_label = vim.fn.strchars(label) > 50 and vim.fn.strcharpart(label, 0, 50) .. "…" or label
            vim_item.abbr = truncated_label

            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Setup command line completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      -- Setup autopairs integration
      -- TODO: FIX!!!!
      -- local cmp_autopairs = require("nvim-autopairs.cmp")
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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



  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      -- Only load which-key mappings, not all mappings
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      -- Add timeout to prevent space from being treated as leader immediately
      timeout = 500,
    },
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}

local config = require("core.utils").load_config()

require("lazy").setup(default_plugins, config.lazy_nvim)
