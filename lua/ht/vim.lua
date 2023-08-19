---@param winnr number?
---@return { [1]: number, [2]: number }
local function get_cursor_0index(winnr)
  winnr = winnr or 0
  local c = vim.api.nvim_win_get_cursor(winnr)
  c[1] = c[1] - 1
  return c
end

return {
  get_cursor_0index = get_cursor_0index,
}
