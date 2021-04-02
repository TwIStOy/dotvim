module('walnut.window', package.seeall)

local va = vim.api
local vfun = vim.api.nvim_call_function
local cmd = vim.api.nvim_command

local auto_close_type = {}
local uncountable_type = {}

local function is_uncountable(win_id)
  local buf_id = va.nvim_win_get_buf(win_id)
  local ft = va.nvim_buf_get_option(buf_id, 'ft')
  local bt = va.nvim_buf_get_option(buf_id, 'buftype')

  return vim.tbl_contains(uncountable_type, ft)
      or vim.tbl_contains(uncountable_type, bt)
end

local function is_not_blocking_vim_quit(win_id)
  local buf_id = va.nvim_win_get_buf(win_id)
  local ft = va.nvim_buf_get_option(buf_id, 'ft')
  local bt = va.nvim_buf_get_option(buf_id, 'buftype')

  return vim.tbl_contains(auto_close_type, ft)
      or vim.tbl_contains(auto_close_type, bt)
end

local function skip_uncountable_window(cnt)
  local rest = cnt
  for k, win_id in pairs(va.nvim_list_wins()) do
    if not is_uncountable(win_id) then
      rest = rest - 1
      if rest == 0 then
        return win_id
      end
    end
  end

  return 0
end

function goto_win(id)
  local win_id = skip_uncountable_window(id)
  if win_id > 0 then
     va.nvim_set_current_win(win_id)
  end
end

function skip_type(tp)
  table.insert(uncountable_type, tp)
  table.insert(auto_close_type, tp)
end

function fast_forward_to_file_explorer()
  local n = vim.api.nvim_call_function('winnr', {'$'})
  for i = 1, n do
    local win_id = vfun('win_getid', { i })
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = va.nvim_buf_get_option(buf_id, 'ft')

    if tp == 'NvimTree' then
      cmd(i .. 'wincmd w')
      return
    end
  end

  require'nvim-tree'.toggle()
end

function quickfix_window_exists()
  local n = vim.api.nvim_call_function('winnr', {'$'})
  for i = 1, n do
    local win_id = vfun('win_getid', { i })
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = va.nvim_buf_get_option(buf_id, 'buftype')

    if tp == 'quickfix' then
      return true
    end
  end

  return false
end

function toggle_quickfix()
  if quickfix_window_exists() then
    cmd('cclose')
  else
    cmd('copen')
  end
end

function check_last_window()
  local n = vim.api.nvim_call_function('winnr', {'$'})
  local total = n
  for i = 1, n do
    local win_id = vfun('win_getid', { i })
    if is_not_blocking_vim_quit(win_id) then
      total = total - 1
    end
  end

  if total == 0 then
    if vim.api.nvim_call_function('tabpagenr', {'$'}) == 1 then
      cmd [[quitall!]]
    else
      cmd [[tabclose]]
    end
  end
end

