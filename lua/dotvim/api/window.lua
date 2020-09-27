module('dotvim.api.window', package.seeall)

local auto_close_window_type = {}

local uncountable_type = {}

-- {{{
local is_uncountable = function(win_id)
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  local ft = vim.api.nvim_buf_get_option(buf_id, 'ft')
  local bt = vim.api.nvim_buf_get_option(buf_id, 'buftype')
  if vim.tbl_contains(uncountable_type, ft) then
    return true
  end
  if vim.tbl_contains(uncountable_type, bt) then
    return true
  end
  return false
end

local skip_uncountable_window = function(cnt)
  local rest = cnt
  for k,win_id in pairs(vim.api.nvim_list_wins()) do
    if not is_uncountable(win_id) then
      rest = rest - 1
      if rest == 0 then
        return win_id
      end
    end
  end
  return 0
end
-- }}}

function toWindow(id)
  local win_id = skip_uncountable_window(id)
  if win_id > 0 then
    vim.api.nvim_set_current_win(win_id)
  end
end

function regUncountableType(tp)
  uncountable_type = vim.tbl_extend('keep', uncountable_type, { tp })
end

-- vim: fdm=marker
