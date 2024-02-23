---@param t table
---@param keys any[]
---@return table
local function select_keys(t, keys)
  local result = {}
  for _, key in ipairs(keys) do
    result[key] = t[key]
  end
  return result
end

---@param t table
---@param keys any[]
---@return table
local function filter_out_keys(t, keys)
  local _keys = {}
  for _, key in ipairs(keys) do
    _keys[key] = true
  end

  local result = {}
  for k, v in pairs(t) do
    if not _keys[k] then
      result[k] = v
    end
  end
  return result
end

return {
  select_keys = select_keys,
  filter_out_keys = filter_out_keys,
}
