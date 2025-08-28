-- =============================================================================
-- Core Neovim Configuration
-- =============================================================================

local opt = vim.opt
local g = vim.g

-- =============================================================================
-- General Settings
-- =============================================================================

-- Disable netrw (use telescope for file browsing)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Set leader key
g.mapleader = " "
g.maplocalleader = " "

-- =============================================================================
-- Editor Options
-- =============================================================================

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance
opt.lazyredraw = true
opt.synmaxcol = 240

-- Backup
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- UI
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 2
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "  ", trail = "·" }

-- =============================================================================
-- Keymaps (Direct Registration)
-- =============================================================================

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Manual which-key trigger (if needed)
map("n", "<leader>?", "<cmd>WhichKey<cr>")

-- Simple keymaps without which-key
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>ee", "<cmd>NERDTreeToggle<cr>")
map("n", "<leader>ef", "<cmd>NERDTreeFind<cr>")
map("n", "<leader>sv", "<C-w>v")
map("n", "<leader>sh", "<C-w>s")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>sx", "<cmd>close<cr>")
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader>nh", "<cmd>nohl<cr>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("n", "<leader>crn", "<cmd>lua vim.lsp.buf.rename()<cr>")
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>")
map("n", "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<cr>")
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>")
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- =============================================================================
-- Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Check tree-sitter availability on startup
autocmd("VimEnter", {
  callback = function()
    if vim.fn.executable("tree-sitter") == 1 then
      vim.notify("Tree-sitter CLI found and ready", vim.log.levels.INFO)
    else
      vim.notify("Tree-sitter CLI not found. Please install tree-sitter-cli", vim.log.levels.WARN)
    end
  end,
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Remove trailing whitespace
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Set indentation for specific file types
autocmd("FileType", {
  pattern = { "yaml", "yml" },
  command = "setlocal ts=2 sw=2 expandtab",
})

autocmd("FileType", {
  pattern = { "python" },
  command = "setlocal ts=4 sw=4 expandtab",
})

-- =============================================================================
-- Health check command
-- =============================================================================

vim.api.nvim_create_user_command("HealthCheck", function()
  local health = require("health")
  health.check_all()
end, {})

-- Treesitter install command
vim.api.nvim_create_user_command("TSInstallAll", function()
  local ok, treesitter = pcall(require, "nvim-treesitter.install")
  if ok then
    vim.cmd("TSInstall lua python json yaml bash dockerfile markdown vim c cpp")
    vim.notify("Treesitter parsers installation started", vim.log.levels.INFO)
  else
    vim.notify("Treesitter not available", vim.log.levels.ERROR)
  end
end, {})

-- Treesitter update command
vim.api.nvim_create_user_command("TSUpdateAll", function()
  local ok, treesitter = pcall(require, "nvim-treesitter.install")
  if ok then
    vim.cmd("TSUpdate")
    vim.notify("Treesitter parsers updated", vim.log.levels.INFO)
  else
    vim.notify("Treesitter not available", vim.log.levels.ERROR)
  end
end, {})

-- Check treesitter status
vim.api.nvim_create_user_command("TSStatus", function()
  local ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if ok then
    local parsers = require("nvim-treesitter.parsers").get_parser_configs()
    local installed = {}
    for parser_name, _ in pairs(parsers) do
      if vim.fn.executable("tree-sitter") == 1 then
        table.insert(installed, parser_name)
      end
    end
    vim.notify("Treesitter parsers: " .. table.concat(installed, ", "), vim.log.levels.INFO)
  else
    vim.notify("Treesitter not available", vim.log.levels.ERROR)
  end
end, {})

-- LSP install command
vim.api.nvim_create_user_command("LSPInstall", function()
  local ok, mason = pcall(require, "mason")
  if ok then
    -- Use pcall to avoid errors if Mason UI is not ready
    pcall(function()
      vim.cmd("MasonInstall lua-language-server pyright json-lsp yaml-language-server bash-language-server docker-langserver marksman")
    end)
    vim.notify("LSP servers installation started", vim.log.levels.INFO)
  else
    vim.notify("Mason not available", vim.log.levels.ERROR)
  end
end, {})

-- Mason status command
vim.api.nvim_create_user_command("MasonStatus", function()
  local ok, mason = pcall(require, "mason")
  if ok then
    -- Use pcall to avoid errors if Mason UI is not ready
    pcall(function()
      vim.cmd("Mason")
    end)
    vim.notify("Mason status checked", vim.log.levels.INFO)
  else
    vim.notify("Mason not available", vim.log.levels.ERROR)
  end
end, {})

-- Clean and reinstall command
vim.api.nvim_create_user_command("CleanInstall", function()
  vim.notify("Cleaning and reinstalling plugins...", vim.log.levels.INFO)
  vim.cmd("Lazy clean")
  vim.cmd("Lazy sync")
  vim.notify("Clean install completed", vim.log.levels.INFO)
end, {})

-- Test which-key command
vim.api.nvim_create_user_command("TestWhichKey", function()
  local ok, which_key = pcall(require, "which-key")
  if ok then
    which_key.show("<leader>")
    vim.notify("Which-key test successful", vim.log.levels.INFO)
  else
    vim.notify("Which-key not available", vim.log.levels.ERROR)
  end
end, {})

-- Debug which-key command
vim.api.nvim_create_user_command("DebugWhichKey", function()
  local ok, which_key = pcall(require, "which-key")
  if ok then
    local mappings = which_key.get_mappings()
    vim.notify("Which-key mappings found: " .. (mappings and "yes" or "no"), vim.log.levels.INFO)
    print("Leader key: " .. (vim.g.mapleader or "not set"))
    print("Which-key available: yes")
  else
    vim.notify("Which-key not available", vim.log.levels.ERROR)
  end
end, {})
