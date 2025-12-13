local M = {}

function M.setup()
    local mappings = {
        n = {
            ['<leader>q'] = { ':q<CR>', 'Quit' },
            ['<leader>w'] = { ':w<CR>', 'Save' },
        }
    }

    for mode, mode_mappings in pairs(mappings) do
        for key, mapping in pairs(mode_mappings) do
            vim.keymap.set(mode, key, mapping[1], { desc = mapping[2] })
        end
    end
end

return M
