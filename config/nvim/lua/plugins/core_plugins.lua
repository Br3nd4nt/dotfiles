local plugins = {
    -- async io
    {"nvim-neotest/nvim-nio", lazy = false}, 
    
    -- utility functions
    {"nvim-lua/plenary.nvim"}, 
    
    -- file explorer
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate"
    }
}

return plugins
