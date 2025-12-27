local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	},
	-- status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto", -- automatically matches your colorscheme
					section_separators = "", -- remove fancy separators
					component_separators = "",
					icons_enabled = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	-- buffer line on top with opened files
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"sudormrfbin/cheatsheet.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" }, -- optional, for fuzzy search
		bundled_cheatsheets = true,
		bundled_plugin_cheatsheets = true,
		include_only_installed_plugins = true,
	},
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
				spelling = { enabled = true, suggestions = 20 },
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
		},
		keys = {
			{
				"<leader>",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			---@type snacks.Config
			opts = {
				animate = { enabled = true },
				bigfile = { enabled = true },
				dashboard = { enabled = true },
				dim = { enabled = true },
				explorer = { enabled = true },
				gh = { enabled = true },
				git = { enabled = true },
				gitbrowse = { enabled = true },
				image = { enabled = true },
				indent = { enabled = true },
				input = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true },
				quickfile = { enabled = true },
				rename = { enabled = true },
				terminal = { enabled = true },
				toggle = { enabled = true },
				util = { enabled = true },
				words = { enabled = true },
				scope = { enabled = true },
				scroll = { enabled = true },
				statuscolumn = { enabled = true },
			},
			keys = {
				{
					"<leader>f",
					function()
						Snacks.picker.smart()
					end,
					desc = "Smart Find Files",
				},
				{
					"<leader>/",
					function()
						Snacks.picker.grep()
					end,
					desc = "Grep",
				},
				{
					"<leader>:",
					function()
						Snacks.picker.command_history()
					end,
					desc = "Command History",
				},
				{
					"<leader>e",
					function()
						Snacks.explorer()
					end,
					desc = "File Explorer",
				},
				{
					"<leader>n",
					function()
						Snacks.picker.notifications()
					end,
					desc = "Notification History",
				},
			},
			config = function(_, opts)
				require("snacks").setup(opts)
				for _, cmd in ipairs({
					{
						"Dim",
						function()
							require("snacks").dim()
						end,
					},
					{
						"SnacksTerminal",
						function()
							require("snacks").terminal.toggle()
						end,
					},
					{
						"SnacksDashboard",
						function()
							require("snacks").dashboard.open()
						end,
					},
					{
						"SnacksQuickfile",
						function()
							require("snacks").quickfile.open()
						end,
					},
					{
						"SnacksPicker",
						function()
							require("snacks").picker.smart()
						end,
					},
				}) do
					vim.api.nvim_create_user_command(cmd[1], cmd[2], {})
				end
			end,
		},
	},
}

return plugins
