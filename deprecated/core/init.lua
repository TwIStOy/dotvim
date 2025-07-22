---@class dotvim.core
local M = {}

---@type dotvim.core.action
M.action = require("dotvim.core.action")

---@type dotvim.core.lsp
M.lsp = require("dotvim.core.lsp")

---@type dotvim.core.plugin
M.plugin = require("dotvim.core.plugin")

---@type dotvim.core.package
M.package = require("dotvim.core.package")

---@type dotvim.core.registry
M.registry = require("dotvim.core.registry")

---@type dotvim.core.vim
M.vim = require("dotvim.core.vim")

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

---@class dotvim.Keymap: vim.api.keyset.keymap
---@field buffer? number

---@param rhs string|fun():any
local function _normalize_rhs(rhs)
  if type(rhs) == "function" then
    return rhs
  end
  -- if rhs startswith 'action:', then it's a action
  if string.find(rhs, "^action:") then
    local name = string.sub(rhs, 8)
    return function()
      M.registry.execute_action(name)
    end
  end
  return function()
    vim.api.nvim_command(rhs)
  end
end

---@param mode string|string[]
---@param lhs string
---@param rhs string|fun():any
---@param opts dotvim.Keymap
function M.set_keymap(mode, lhs, rhs, opts)
  rhs = _normalize_rhs(rhs)
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
