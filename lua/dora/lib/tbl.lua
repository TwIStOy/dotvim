---@class dora.lib.tbl
local M = {}

---@param t table
---@param ... string
function M.optional_field(t, ...)
  local keys = { ... }
  local now = t
  for _, key in ipairs(keys) do
    if now[key] == nil then
      return nil
    end
    now = now[key]
  end
  return now
end

---Reverse given list-like table in place.
---NOTE: this mutates the given table.
---@generic T
---@param lst T[]
function M.list_reverse(lst)
  for i = 1, math.floor(#lst / 2) do
    local j = #lst - i + 1
    lst[i], lst[j] = lst[j], lst[i]
  end
end

---@param t table
---@return table
function M.filter_out_keys(t, keys)
  local res = {}
  for k, v in pairs(t) do
    if not vim.tbl_contains(keys, k) then
      res[k] = v
    end
  end
  return res
end

return M
