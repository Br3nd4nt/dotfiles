local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "cpp", "c", "python", "swift" },
			highlight = { enable = true },
		},
		config = function(_, opts)
			local tree = require("nvim-treesitter")
			tree.setup(opts)

			vim.treesitter.language.register("cpp", "metal")
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = { "pyright", "clangd" },
		},
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
			-- sourcekit-lsp ships with Xcode, not Mason.
			vim.lsp.config("sourcekit", {
				cmd = { "xcrun", "sourcekit-lsp" },
				filetypes = { "swift", "objc", "objcpp" },
			})
			vim.lsp.enable("sourcekit")
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- loads VSCode snippets
		end,
	},

	{
		"saghen/blink.cmp",
		dependencies = { "L3MON4D3/LuaSnip" },
		lazy = false,
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- snippets = { preset = 'luasnip' },
			keymap = { preset = "default" },
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				ghost_text = { enabled = true },
				menu = {
					auto_show = true,
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					-- window = {
					--   border = "rounded",
					-- },
				},
			},
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}

return plugins
