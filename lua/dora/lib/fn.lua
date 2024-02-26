---@class dora.lib.fn
local M = {}

---@generic T
---@param name string
---@param callback fun(module): T
---@return T?
function M.require_then(name, callback)
  local has_module, module = pcall(require, name)
  if has_module then
    return callback(module)
  end
end

---@param callback string|fun(): any
---@param feedkeys? boolean
---@return fun(): any
function M.normalize_callback(callback, feedkeys)
  if type(callback) == "string" then
    if feedkeys == true then
      return function()
        local key = vim.api.nvim_replace_termcodes(
          callback .. "<Ignore>",
          true,
          false,
          true
        )
        vim.api.nvim_feedkeys(key, "t", false)
      end
    else
      return function()
        vim.api.nvim_command(callback)
      end
    end
  else
    return callback
  end
end

return M
