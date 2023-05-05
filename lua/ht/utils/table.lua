local M = {}

M.keys = function(t)
  return vim.tbl_keys(t)
end

---Unique elements in given list-like table.
---@param t List
---@return List
M.unique = function(t)
  local hash = {}
  for _, v in ipairs(t) do
    hash[v] = true
  end
  return vim.tbl_keys(hash)
end

---Find the first element in given list-like table that satisfies the given predicate.
---@param t List
---@param predicate function
---@return any|nil
M.find_first = function(t, predicate)
  for _, v in ipairs(t) do
    if predicate(v) then
      return v
    end
  end
  return nil
end

---Returns true if the given list-like table contains an element that satisfies the given predicate.
---@param t List
---@param predicate function
---@return boolean
M.contains = function(t, predicate)
  return M.find_first(t, predicate) ~= nil
end

M.slice = function(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
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
---@param lst Array
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

---@param lst Array
---@param f function
---@return Array
M.list_map = function(lst, f)
  local res = {}
  for _, v in ipairs(lst) do
    table.insert(res, f(v))
  end
  return res
end

---@param p string|table|string[]
M.normalize_search_table = function(p)
  if p == nil then
    return nil
  end
  if type(p) == "string" then
    return { [p] = true }
  elseif type(p) == "table" then
    if vim.tbl_islist(p) then
      local res = {}
      for _, v in ipairs(p) do
        res[v] = true
      end
      return res
    else
      return p
    end
  end
end

return M

-- vim: et sw=2 ts=2 fdm=marker
