-- n, v, i, t = mode names

local M = {}

M.general = {
  n = {
    ["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-l>"] = { "<C-w>l", "Window right" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

    -- LSP
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Documentation" },
    
    -- Basic operations
    ["<leader>s"] = { "<cmd> w <CR>", "Save file" },
    ["<leader>q"] = { "<cmd> q <CR>", "Quit" },
    ["<leader>nh"] = { "<cmd> noh <CR>", "Clear highlights" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["<"] = { "<gv", "Indent line" },
    [">"] = { ">gv", "Indent line" },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
  },
}

M.telescope = {
  -- Lazy load telescope mappings
  lazy = true,
  
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <cr>", "Find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <cr>", "Find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <cr>", "Live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <cr>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <cr>", "Help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <cr>", "Find oldfiles" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <cr>", "Find in current buffer" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <cr>", "Git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <cr>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <cr>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <cr>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <cr>", "telescope bookmarks" },
  },
}

M.nvimtree = {

  n = {
    -- toggle
    ["<leader>ee"] = { "<cmd> NvimTreeToggle <cr>", "Toggle nvimtree" },

    -- focus
    ["<leader>ef"] = { "<cmd> NvimTreeFocus <cr>", "Focus nvimtree" },
  },
}

M.windows = {

  n = {
    -- split management
    ["<leader>sv"] = { "<C-w>v", "Split vertically" },
    ["<leader>sh"] = { "<C-w>s", "Split horizontally" },
    ["<leader>se"] = { "<C-w>=", "Equalize windows" },
    ["<leader>sx"] = { "<cmd> close <CR>", "Close window" },
  },
}



M.code = {

  n = {
    -- code actions
    ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    ["<leader>cr"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    ["<leader>cf"] = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
  },
}

M.diagnostics = {

  n = {
    -- diagnostics
    ["<leader>ds"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show Diagnostics" },
    ["<leader>dn"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    ["<leader>dp"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
  },
}

M.lspconfig = {

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["<leader>cr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>cf"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },

    ["<leader>ds"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    ["<leader>dn"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },

    ["<leader>dp"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Goto prev",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  },

  v = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
  },
}

M.whichkey = {

  n = {
    ["<Space>"] = {
      function()
        require("which-key").show("", { mode = "n" })
      end,
      "Show which-key root menu",
    },
  },
}

return M
