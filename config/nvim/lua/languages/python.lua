local packages = {
{
  "mfussenegger/nvim-dap",
  lazy=false,
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dapui = require("dapui")
    dapui.setup()

    -- Point to uv's .venv Python
    require("dap-python").setup(vim.fn.getcwd() .. "/.venv/bin/python")

    local dap = require("dap")
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  end,
},

}

return packages
