local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "cpp", "c" },
			highlight = { enable = true },
		},
		config = function(_, opts)
			local tree = require("nvim-treesitter")
			tree.setup(opts)

			vim.treesitter.language.register("cpp", "metal")
		end,
	},
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
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
}

return plugins
