local UtilTs = require("ht.utils.ts")
local ts_utils = require("nvim-treesitter.ts_utils")

local function remove_if_statement_surround_text_edits()
  local current = ts_utils.get_node_at_cursor()

  ---@type TSNode
  local if_root = UtilTs.find_parent(current, "if_statement")
  if if_root == nil then
    return nil
  end

  -- child 0: keyword 'if'
  -- child 1: condition (named)
  -- child 2: keyword 'then'
  -- child n-1: keyword 'end'

  local child_cnt = if_root:child_count() - 1

  -- keyword if, left start
  local left_start_row, left_start_col, _, _ = if_root:child(0):range()
  local _, _, left_end_row, left_end_col = if_root:child(2):range()
  local right_start_row, right_start_col, right_end_row, right_end_col =
    if_root:child(child_cnt):range()

  return {
    {
      range = {
        start = {
          line = left_start_row,
          character = left_start_col,
        },
        ["end"] = {
          line = left_end_row,
          character = left_end_col,
        },
      },
      newText = "",
    },
    {
      range = {
        start = {
          line = right_start_row,
          character = right_start_col,
        },
        ["end"] = {
          line = right_end_row,
          character = right_end_col,
        },
      },
      newText = "",
    },
  }
end

return {
  test = remove_if_statement_surround_text_edits,
  apply = function()
    local text_edits = remove_if_statement_surround_text_edits()
    if text_edits ~= nil then
      vim.lsp.util.apply_text_edits(text_edits, 0, 'utf-8')
    end
  end
}
