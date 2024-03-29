---@class dotvim.core
local M = {}

---@type dotvim.core.action
M.action = require("dotvim.core.action")

---@type dotvim.core.lsp
M.lsp = require("dotvim.core.lsp")

---@param cmd string|fun(string):any
---@return fun():any
function M.input_then_exec(cmd)
  local function callback(input)
    if type(cmd) == "string" then
      vim.api.nvim_command(cmd .. input)
    else
      cmd(input)
    end
  end

  return function()
    vim.ui.input({
      prompt = "Arguments, " .. cmd,
    }, function(input)
      if input then
        callback(input)
      end
    end)
  end
end

return M
