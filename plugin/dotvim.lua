_G.dv = _G.dv or {} --[[@as table]]

--- @private
--- @generic T
--- @param root string
--- @param defines T
--- @return T
function dv._defer_require(root, defines) ---@diagnostic disable-line: unused-local
  return setmetatable({}, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      local name = string.format("%s.%s", root, k)
      local mod = require(name)
      if not mod then
        error(mod)
      end
      rawset(t, k, mod)
      return mod
    end,
  })
end

---@param co thread
---@param timeout integer?
function dv._wait_coroutine(co, timeout)
  timeout = timeout or (10 * 1000)
  local result = vim.wait(timeout, function()
    local status = coroutine.status(co)
    if status == "dead" then
      return true
    end
    return false
  end)
  if not result then
    error("Timeout waiting for coroutine")
  end
end

--[[
Very useful functions, exposed in the global scope
--]]
local commons = require("dotvim.commons")

dv.on_lsp_attach = commons.lsp.on_lsp_attach
