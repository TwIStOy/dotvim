-- Helper functions for color resolution
local function resolve_fg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil or info.fg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.fg)
end

local function resolve_bg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil or info.bg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.bg)
end

return {
  resolve_fg = resolve_fg,
  resolve_bg = resolve_bg,
}
