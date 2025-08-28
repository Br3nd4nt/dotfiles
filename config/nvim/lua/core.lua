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
-- LSP Setup with Mason
-- =============================================================================

-- Setup Mason
pcall(function()
  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })
end)

-- Setup LSP servers
pcall(function()
  local lspconfig = require("lspconfig")
  
  -- LSP servers configuration
  local servers = {
    -- Lua
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
    
    -- Python
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
          },
        },
      },
    },
    
    -- JSON
    jsonls = {
      settings = {
        json = {
          validate = { enable = true },
        },
      },
    },
    
    -- YAML
    yamlls = {
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.{yml,yaml}",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
          },
        },
      },
    },
    
    -- Bash
    bashls = {
      settings = {
        bash = {
          validate = true,
        },
      },
    },
    
    -- Docker
    dockerls = {
      settings = {
        docker = {
          languageserver = {
            formatter = {
              ignore = {},
            },
          },
        },
      },
    },
    
    -- Markdown
    marksman = {},
    
    -- Swift
    sourcekit = {},
  }
  
  -- Setup each server
  for server_name, config in pairs(servers) do
    pcall(function()
      lspconfig[server_name].setup(config)
    end)
  end
  
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
end)
