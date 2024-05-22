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

return M
