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

return M
