local M = {}

M.keys = function(t)
  if type(t) ~= 'table' then
    return nil
  end

  local res = {}
  for k, _ in pairs(t) do
    table.insert(res, k)
  end
  return res
end

M.unique = function(t)
  if type(t) ~= table then
    return nil
  end

  local hash = {}
  for _, v in ipairs(t) do
    hash[v] = true
  end
  return M.keys(hash)
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

-- reverse given list-like table
M.list_reverse = function(lst)
  for i = 1, math.floor(#lst / 2) do
    local j = #lst - i + 1
    lst[i], lst[j] = lst[j], lst[i]
  end
end

return M
-- vim: et sw=2 ts=2 fdm=marker

