-- =============================================================================
-- Health Check Configuration
-- =============================================================================

-- This file provides health check functions for Neovim

local M = {}

-- Check Neovim version compatibility
function M.check_version()
  local ok, version = pcall(vim.version)
  if ok and version then
    if version.major >= 0 and version.minor >= 9 then
      vim.health.ok(string.format("Neovim version: %d.%d.%d", version.major, version.minor, version.patch))
    else
      vim.health.warn(string.format("Neovim version: %d.%d.%d (some features may not work)", version.major, version.minor, version.patch))
    end
  else
    vim.health.warn("Could not determine Neovim version")
  end
  return true
end

-- Check if Lazy.nvim is working
function M.check_lazy()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.health.error("Lazy.nvim not found")
    return false
  end
  
  vim.health.ok("Lazy.nvim found")
  return true
end

-- Check if plugins are loaded
function M.check_plugins()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.health.error("Cannot check plugins - Lazy.nvim not found")
    return false
  end
  
  local success, plugins = pcall(lazy.plugins)
  if success and plugins and #plugins > 0 then
    vim.health.ok(string.format("Found %d plugins", #plugins))
  else
    vim.health.warn("No plugins found or Lazy not ready")
  end
  
  return true
end

-- Check LSP setup
function M.check_lsp()
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    vim.health.error("LSP config not found")
    return false
  end
  
  local ok_mason, mason = pcall(require, "mason")
  if not ok_mason then
    vim.health.warn("Mason not found")
  else
    vim.health.ok("Mason found")
    
    -- Check if Mason is ready
    local ok_registry, registry = pcall(require, "mason-registry")
    if ok_registry then
      local success, installed_packages = pcall(registry.get_all_installed_package_names)
      if success and installed_packages and #installed_packages > 0 then
        vim.health.ok(string.format("Mason has %d installed packages", #installed_packages))
      else
        vim.health.warn("Mason has no installed packages or registry not ready")
      end
    else
      vim.health.warn("Mason registry not available")
    end
  end
  
  vim.health.ok("LSP config found")
  return true
end

-- Check Treesitter
function M.check_treesitter()
  local ok, treesitter = pcall(require, "nvim-treesitter.configs")
  if not ok then
    vim.health.error("Treesitter not found")
    return false
  end
  
  -- Check if parsers are available
  local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok_parsers then
    local success, available_parsers = pcall(parsers.get_parser_configs)
    if success and available_parsers then
      local installed_parsers = {}
      
      for parser_name, _ in pairs(available_parsers) do
        table.insert(installed_parsers, parser_name)
      end
      
      if #installed_parsers > 0 then
        vim.health.ok(string.format("Treesitter found with %d parsers", #installed_parsers))
      else
        vim.health.warn("Treesitter found but no parsers installed")
      end
    else
      vim.health.warn("Treesitter parsers not available")
    end
  else
    vim.health.ok("Treesitter found")
  end
  
  -- Check if tree-sitter CLI is available
  if vim.fn.executable("tree-sitter") == 1 then
    vim.health.ok("Tree-sitter CLI found")
  else
    vim.health.warn("Tree-sitter CLI not found - install tree-sitter-cli")
  end
  
  return true
end

-- Main health check function
function M.check_all()
  -- Note: vim.health.report_start/end are not available in Neovim < 0.9.0
  -- Using direct health reporting instead
  
  M.check_version()
  M.check_lazy()
  M.check_plugins()
  M.check_lsp()
  M.check_treesitter()
end

return M
