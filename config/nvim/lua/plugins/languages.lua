local plugins = {
    -- Mason lsp server
    {"mason-org/mason.nvim", opts = {}}, 
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
                "bashls",
                "dockerls",
                "clangd",
            }
        },
        dependencies = {
            {"mason-org/mason.nvim", opts = {}}, "neovim/nvim-lspconfig"
        }
    }
}

return plugins
