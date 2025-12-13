vim.g.mapleader = " "
vim.g.maplocalleader = " "

local plugins = {
    -- notifications
    {"j-hui/fidget.nvim"}, -- completion
    {
        'saghen/blink.cmp',
        version = "1.*",
        -- optional: provides snippets for the snippet source
        dependencies = {'rafamadriz/friendly-snippets'},

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {preset = 'default'},

            appearance = {nerd_font_variant = 'mono'},

            completion = {documentation = {auto_show = true}},

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {default = {'lsp', 'path', 'snippets', 'buffer'}},
            fuzzy = {implementation = "prefer_rust"}
        },
        opts_extend = {"sources.default"}
    }, -- themes
    {
      "rebelot/kanagawa.nvim",
      lazy = false,  -- load immediately
      priority = 1000, -- make sure it loads before other UI plugins
      config = function()
        vim.cmd("colorscheme kanagawa-dragon") -- or your preferred default
      end
    },
    {
        "zaldih/themery.nvim",
        lazy = false,
        -- config = function()
        --   require("themery").setup({
        --       themes = {{
        --         name = "Day",
        --         colorscheme = "kanagawa-lotus",
        --       },
        --       {
        --         name = "Night",
        --         colorscheme = "kanagawa-dragon",
        --       }},
        --   })
        -- end
    }, -- status bar
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"}, -- optional, for icons
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto", -- automatically matches your colorscheme
                    section_separators = "", -- remove fancy separators
                    component_separators = "",
                    icons_enabled = true
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch", "diff", "diagnostics"},
                    lualine_c = {{"filename", path = 1}},
                    lualine_x = {"encoding", "filetype"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                }
            })
        end
    }, -- buffer line
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    }, {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {}
    }, -- helper with key mapping
    { 'nvim-mini/mini.nvim', version = false },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {
            plugins = {
                marks = true,
                registers = true,
                spelling = {enabled = true, suggestions = 20},
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true
                }
            },
        },
        config = function(_, opts)
            
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
               mode = { "n", "v" },
               { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
               { "<leader>w", "<cmd>w<cr>", desc = "Write" },
               { "<leader>h", function() wk.show("", { mode = "n" }) end, desc = "Show keybindings" },
            })
        end,

    }, {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = {enabled = true},
            dashboard = {enabled = true},
            explorer = {enabled = true},
            indent = {enabled = true},
            input = {enabled = true},
            picker = {enabled = true},
            notifier = {enabled = true},
            quickfile = {enabled = true},
            scope = {enabled = true},
            scroll = {enabled = true},
            statuscolumn = {enabled = true},
            words = {enabled = true}
        }
    }
}

return plugins
