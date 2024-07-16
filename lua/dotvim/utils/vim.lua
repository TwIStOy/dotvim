---@class dotvim.utils.vim
local M = {}

function M.cursor0_to_editor()
  local win = vim.api.nvim_get_current_win()
  local win_row = unpack(vim.api.nvim_win_get_position(win))
  local row = unpack(vim.api.nvim_win_get_cursor(win))
  local line_start = vim.api.nvim_call_function("line", { "w0" })
  local col = vim.fn.screencol()
  return win_row + row - line_start, col
end

---@param group string
---@return string
function M.resolve_fg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
    link = false,
  })
  if info == nil or info.fg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.fg)
end

---@param group string
---@return string
function M.resolve_bg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil or info.bg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.bg)
end

function M.resolve_color(group)
  return { fg = M.resolve_fg(group), bg = M.resolve_bg(group) }
end

function M.hex_to_rgb(hex)
  if hex == nil or hex == "None" then
    return { 0, 0, 0 }
  end

  hex = hex:gsub("#", "")
  hex = string.lower(hex)

  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha

  local fg = M.hex_to_rgb(foreground)
  local bg = M.hex_to_rgb(background)

  local blend_channel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string
    .format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
    :upper()
end

---Returns the keymap for a given mode and lhs
---@param mode string
---@param lhs string
---@return vim.api.keyset.keymap?
function M.get_keymap(mode, lhs)
  local keymap = vim.api.nvim_get_keymap(mode)
  for _, map in ipairs(keymap) do
    ---@diagnostic disable-next-line: undefined-field
    if map.lhs == lhs then
      return map
    end
  end
  return nil
end

---Returns the value of a buffer variable, or nil if it doesn't exist.
---@param bufnr number
---@param key string
---@return any
function M.buf_get_var(bufnr, key)
  local succ, value = pcall(vim.api.nvim_buf_get_var, bufnr, key)
  if succ then
    return value
  end
end

return M
