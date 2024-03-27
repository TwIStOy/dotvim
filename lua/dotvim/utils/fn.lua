---@class dotvim.utils.fn
local M = {}

---@generic T
---@param fun fun():T
---@return fun():T
function M.invoke_once(fun)
  local res
  local invoked = false
  return function()
    if not invoked then
      res = fun()
      invoked = true
    end
    return res
  end
end

return M
