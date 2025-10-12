local plugins = {
    -- fuzzy finder
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- file explorer
    {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}
    end,
    },
    -- toogle term 
    -- TODO: configure
    {
        'akinsho/toggleterm.nvim', 
        version = "*", 
        config = true
    },
    -- gcc commenting
    {
    'numToStr/Comment.nvim',
    },
    -- surround
    -- TODO: figure out how to use
    {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
        })
    end
    },
    -- auto pairs
    {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    }
}

return plugins