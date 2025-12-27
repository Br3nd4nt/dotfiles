local M = {}

function M.setup()
	local keymap = vim.keymap.set
	local mappings = {
		n = {
			["<leader>q"] = { ":q<CR>", "Quit" },
			["<leader>w"] = { ":w<CR>", "Save" },
		},
	}

	for mode, mode_mappings in pairs(mappings) do
		for key, mapping in pairs(mode_mappings) do
			keymap(mode, key, mapping[1], { desc = mapping[2] })
		end
	end

	-- Delete without yanking (black hole register)
	keymap("n", "d", '"_d', { noremap = true })
	keymap("n", "x", '"_x', { noremap = true })
	keymap("v", "d", '"_d', { noremap = true })

	keymap("n", "c", '"_c', { noremap = true })
	keymap("v", "c", '"_c', { noremap = true })

	-- force to use hjkl (fuck your arrows)
	for _, mode in ipairs({ "n", "v" }) do
		keymap(mode, "<Up>", "<Nop>", { noremap = true })
		keymap(mode, "<Down>", "<Nop>", { noremap = true })
		keymap(mode, "<Left>", "<Nop>", { noremap = true })
		keymap(mode, "<Right>", "<Nop>", { noremap = true })
	end
end

return M
