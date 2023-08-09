local M = {}

M.keys = function(t)
  return vim.tbl_keys(t)
end

---Unique elements in given list-like table.
---@generic T
---@param t T[]
---@return T[]
M.unique = function(t)
  local hash = {}
  for _, v in ipairs(t) do
    hash[v] = true
  end
  return vim.tbl_keys(hash)
end

---Find the first element in given list-like table that satisfies the given predicate.
---@generic T
---@param t T[]
---@param predicate fun(T):boolean
---@return T|nil
M.find_first = function(t, predicate)
  for _, v in ipairs(t) do
    if predicate(v) then
      return v
    end
  end
  return nil
end

---Returns true if the given list-like table contains an element that
---satisfies the given predicate.
---@generic T
---@param t T[]
---@param predicate fun(T):boolean
---@return boolean
M.contains = function(t, predicate)
  return M.find_first(t, predicate) ~= nil
end

---Returns slice of given list-like table.
---@generic T
---@param tbl T[]
---@param first number?
---@param last number?
---@param step number?
---@return T[]
M.slice = function(tbl, first, last, step)
  local sliced = {}

  first = first or 1
  last = last or #tbl
  step = step or 1

  for i = first, last, step do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

M.table_get_value = function(t, k, default)
  if t[k] ~= nil then
    return t[k]
  else
    return default
  end
end

---Reverse given list-like table in place.
---NOTE: this mutates the given table.
---@generic T
---@param lst T[]
M.list_reverse = function(lst)
  for i = 1, math.floor(#lst / 2) do
    local j = #lst - i + 1
    lst[i], lst[j] = lst[j], lst[i]
  end
end

---Deep-copy a table.
---@param orig table
---@return table
M.deepcopy = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
    end
    setmetatable(copy, M.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

---@generic T
---@generic U
---@param lst T[]
---@param f fun(T):U
---@return U[]
M.list_map = function(lst, f)
  local res = {}
  for _, v in ipairs(lst) do
    res[#res + 1] = f(v)
  end
  return res
end

---@generic T
---@generic U
---@param lst T[]
---@param f fun(T):U
---@return U[]
M.list_map_filter = function(lst, f)
  local res = {}
  for _, v in ipairs(lst) do
    local vv = f(v)
    if vv ~= nil then
      res[#res + 1] = vv
    end
  end
  return res
end

---@param p string|table|string[]|nil
---@return table?
M.normalize_search_table = function(p)
  if p == nil then
    return nil
  end

  vim.validate { p = { p, { "string", "table" } } }
  if type(p) == "string" then
    return { [p] = true }
  elseif type(p) == "table" and vim.tbl_islist(p) then
    local res = {}
    for _, v in ipairs(p) do
      res[v] = true
    end
    return res
  end
  return p
end

---@param fathers table[]
---@return fun(table, string):any
M.make_index_function = function(fathers)
  return function(_, key)
    for _, father in ipairs(fathers) do
      if father[key] ~= nil then
        return father[key]
      end
    end
    return nil
  end
end

return M
