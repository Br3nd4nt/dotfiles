local plugins = {
	-- time spent coding stats
	{ "wakatime/vim-wakatime", lazy = false },
	-- gcc commenting
	{
		"numToStr/Comment.nvim",
	},
	-- surround
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					swift = { "swiftformat" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					metal = { "clang_format" },
					cpp = { "clang_format" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}

return plugins
