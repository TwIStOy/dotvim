---@param t table
---@param ... string[]
local function optional_field(t, ...)
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

return {
  optional_field = optional_field,
}
