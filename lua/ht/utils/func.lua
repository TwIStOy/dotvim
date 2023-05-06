local M = {}

---@param func function
function M.call_once(func)
  local once_flag = false
  return function()
    if once_flag then
      return
    end
    once_flag = true
    func()
  end
end

return M
