local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

local plugin_files = {
    "plugins.core_plugins", "plugins.languages", "plugins.tools", "plugins.ui"
}

local all_plugins = {}

for _, module in ipairs(plugin_files) do
    local ok, mod = pcall(require, module)
    if ok and type(mod) == "table" then
        vim.list_extend(all_plugins, mod)
    else
        vim.notify("[Custom loader] Failed to load " .. module,
                   vim.log.levels.ERROR)
    end
end

local default_config = {}

default_config.lazy_nvim = {
    {
        defaults = {lazy = true},
        install = {},
        ui = {border = "rounded"},
        performance = {}
    }
}

require("lazy").setup(all_plugins, default_config.lazy_nvim)
