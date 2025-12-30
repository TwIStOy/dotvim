-- Helper functions for color resolution

---Recursively resolve a color attribute from a highlight group
---@param group string The highlight group name
---@param attr "fg"|"bg" The color attribute to resolve
---@return string The color in hex format or "NONE"
local function resolve_hl_attr(group, attr)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil then
    return "NONE"
  end
  -- If linked to another group, recursively resolve
  if info.link then
    return resolve_hl_attr(info.link, attr)
  end
  if info[attr] == nil then
    return "NONE"
  end
  return string.format("#%06x", info[attr])
end

---Recursively resolve foreground color of a highlight group
---@param group string The highlight group name
---@return string The foreground color in hex format or "NONE"
local function resolve_fg(group)
  return resolve_hl_attr(group, "fg")
end

---Recursively resolve background color of a highlight group
---@param group string The highlight group name
---@return string The background color in hex format or "NONE"
local function resolve_bg(group)
  return resolve_hl_attr(group, "bg")
end

return {
  resolve_fg = resolve_fg,
  resolve_bg = resolve_bg,
}
