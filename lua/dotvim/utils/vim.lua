---@class dotvim.utils.vim
local M = {}

function M.cursor0_to_editor()
  local win = vim.api.nvim_get_current_win()
  local win_row = unpack(vim.api.nvim_win_get_position(win))
  local row = unpack(vim.api.nvim_win_get_cursor(win))
  local line_start = vim.api.nvim_call_function("line", { "w0" })
  local col = vim.fn.screencol()
  print(row, col)
  return win_row + row - line_start, col
end

return M
