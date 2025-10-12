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

-- =============================================================================
-- Editor Options
-- =============================================================================

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
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
opt.wrap = true
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "  ", trail = "·" }
