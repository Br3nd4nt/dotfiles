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

     local keymap = vim.keymap.set

    -- Delete without yanking (black hole register)
    keymap("n", "d", '"_d', { noremap = true })
    keymap("n", "x", '"_x', { noremap = true })
    keymap("v", "d", '"_d', { noremap = true })

    -- Optional: keep change from polluting clipboard
    keymap("n", "c", '"_c', { noremap = true })
    keymap("v", "c", '"_c', { noremap = true })


end

return M
