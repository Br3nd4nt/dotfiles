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
-- Keymaps
-- =============================================================================

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Telescope (fuzzy finder)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- NERDTree
map("n", "<leader>e", "<cmd>NERDTreeToggle<cr>")
map("n", "<leader>ef", "<cmd>NERDTreeFind<cr>")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Window management
map("n", "<leader>sv", "<C-w>v")
map("n", "<leader>sh", "<C-w>s")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>sx", "<cmd>close<cr>")

-- Quick save and quit
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- Clear search
map("n", "<leader>nh", "<cmd>nohl<cr>")

-- =============================================================================
-- Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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
-- LSP Keymaps
-- =============================================================================

-- LSP keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- LSP keymaps
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>")
map("n", "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<cr>")
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>")
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

-- Health check command
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
