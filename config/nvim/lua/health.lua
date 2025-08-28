-- =============================================================================
-- Health Check Configuration
-- =============================================================================

-- This file provides health check functions for Neovim

local M = {}

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
  
  local plugins = lazy.plugins()
  if not plugins or #plugins == 0 then
    vim.health.warn("No plugins found")
    return false
  end
  
  vim.health.ok(string.format("Found %d plugins", #plugins))
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
      local installed_packages = registry.get_all_installed_package_names()
      if #installed_packages > 0 then
        vim.health.ok(string.format("Mason has %d installed packages", #installed_packages))
      else
        vim.health.warn("Mason has no installed packages")
      end
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
    local available_parsers = parsers.get_parser_configs()
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
    vim.health.ok("Treesitter found")
  end
  
  return true
end

-- Main health check function
function M.check_all()
  vim.health.report_start("Neovim Configuration Health Check")
  
  M.check_lazy()
  M.check_plugins()
  M.check_lsp()
  M.check_treesitter()
  
  vim.health.report_end()
end

return M
