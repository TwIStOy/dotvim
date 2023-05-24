local M = {}
local cond = require("ht.snippets.conditions.cond")

local function at_first_line()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  return row == 1
end

local function all_lines_before_match(pattern)
  local function condition(line_to_cursor, _matched_trigger, _captures)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)
    for _, line in ipairs(lines) do
      if not line:match(pattern) then
        return false
      end
    end
    return true
  end
  return cond.make_condition(condition, condition)
end

local function line_begin_cond(line_to_cursor, matched_trigger, _captures)
  if matched_trigger == nil or line_to_cursor == nil then
    return false
  end
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$")
end

local function line_begin_show_maker(trig)
  local function line_begin_show(line_to_cursor)
    if line_to_cursor == nil then
      return false
    end
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local trigger = line:sub(1, col):match("%S+$")
    if #trigger > #trigger then
      return false
    end
    return trigger == trig:sub(1, #trigger)
  end
  return line_begin_show
end

local function at_line_begin(trig)
  return cond.make_condition(line_begin_cond, line_begin_show_maker(trig))
end
return {
  all_lines_before_match = all_lines_before_match,
  at_line_begin = at_line_begin,
  at_first_line = cond.make_condition(at_first_line, at_first_line),
}
