---@class dotvim.utils.tbl
local M = {}

---@generic T
---@param t1? T[]
---@param t2? T[]
---@return T[]
function M.merge_array(t1, t2)
  if t1 == nil then
    return t2 or {}
  end
  if t2 == nil then
    return t1
  end
  local res = {}
  vim.list_extend(res, t1)
  vim.list_extend(res, t2)
  return res
end

return M
