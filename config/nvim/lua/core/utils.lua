local M = {}
local merge_tb = vim.tbl_deep_extend

M.load_config = function()
  local config = require "core.default_config"
  return config
end

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      -- Skip lazy sections unless explicitly requested
      if section_values.lazy and section ~= section_values.lazy then
        return
      end

      section_values.lazy = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- merge default + user opts
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    local mappings = require("core.mappings")

    if type(section) == "string" then
      mappings = mappings[section] and { [section] = mappings[section] } or {}
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

return M
