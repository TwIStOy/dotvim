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

local function normalize_search_table(tbl)
  if vim.tbl_isarray(tbl) then
    local ret = {}
    for _, v in ipairs(tbl) do
      ret[#ret + 1] = v
    end
    return ret
  else
    return tbl
  end
end

---@param t table
---@param keys string[]
---@return table
function M.filter_out_keys(t, keys)
  local res = {}
  local _keys = normalize_search_table(keys)
  for k, v in pairs(t) do
    if _keys[k] ~= nil then
      res[k] = v
    end
  end
  return res
end

---@param tbl any
---@return any[]
function M.flatten_array(tbl)
  if type(tbl) ~= "table" then
    return { tbl }
  end

  if vim.tbl_isarray(tbl) then
    local res = {}
    for _, value in ipairs(tbl) do
      local inner_value = M.flatten_array(value)
      res = vim.list_extend(res, inner_value)
    end
    return res
  else
    return { tbl }
  end
end

---@generic T
---@param tbl T[]
---@param fn fun(T, T):T
---@param acc T
function M.foldl(tbl, fn, acc)
  for _, v in ipairs(tbl) do
    acc = fn(acc, v)
  end
  return acc
end

---@generic T
---@param tbl T[]
---@param fn fun(T, T):T
---@param acc T
function M.foldr(tbl, fn, acc)
  for i = #tbl, 1, -1 do
    acc = fn(tbl[i], acc)
  end
  return acc
end

---@param value any
---@param tbl table
---@param ... string
function M.tbl_set(value, tbl, ...)
  local len = select("#", ...)
  local keys = { ... }
  local now = tbl
  for i, key in ipairs(keys) do
    if i == len then
      now[key] = value
    else
      if now[key] == nil then
        now[key] = {}
      end
      now = now[key]
      if type(now) ~= "table" then
        error("tbl_set: key " .. key .. " is not a table")
      end
    end
  end
  return tbl
end

---@generic T
---@generic U
---@param array U[]
---@param init T
---@param fn fun(T, U):T
---@return T
function M.reduce_left(array, init, fn)
  local ret = init
  for _, v in ipairs(array) do
    ret = fn(ret, v)
  end
  return ret
end

return M
