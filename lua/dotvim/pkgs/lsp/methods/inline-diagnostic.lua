local MAX_ALLOWED_LINES = 20

---@param diagnostics vim.Diagnostic[]
local function get_current_pos_diags(diagnostics, curline, curcol)
  local current_pos_diags = {}

  for _, diag in ipairs(diagnostics) do
    if
      diag.lnum == curline
      and curcol >= diag.col
      and curcol <= diag.end_col
    then
      table.insert(current_pos_diags, diag)
    end
  end

  if next(current_pos_diags) == nil then
    if #diagnostics == 0 then
      return current_pos_diags
    end
    table.insert(current_pos_diags, diagnostics[1])
  end

  return current_pos_diags
end

--- @param chunks string[]
--- @return number
local function get_max_width_from_chunks(chunks)
  local max_chunk_line_length = 0

  for _, chunk in ipairs(chunks) do
    if #chunk > max_chunk_line_length then
      max_chunk_line_length = #chunk
    end
  end

  return max_chunk_line_length
end

---@param win number
---@return vim.Diagnostic[]
local function get_diagnostic_under_cursor(win)
  local cursor_pos = vim.api.nvim_win_get_cursor(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local curline = cursor_pos[1] - 1

  ---@type vim.Diagnostic[]
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = curline })
  return diagnostics
end
