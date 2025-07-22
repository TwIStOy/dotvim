---@class dotvim.utils.value
local M = {}

---@generic T
---@param value T|fun(...): T
---@param ... any
---@return T
function M.normalize_value(value, ...)
  if type(value) == "function" then
    return value(...)
  end
  return value
end

return M
