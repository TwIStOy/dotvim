module('ht.core.window', package.seeall)

local vcall = vim.api.nvim_call_function
local cmd = vim.api.nvim_command
local va = vim.api

--[[
uncountable filetypes and buftypes will be ignored when windows counting and
will not block vim quiting.
--]]
local uncountable_types = {}

function Skip(tp)
  uncountable_types[tp] = true
end

local function is_uncountable(win_id)
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  local ft = vim.api.nvim_buf_get_option(buf_id, 'ft')
  local bt = vim.api.nvim_buf_get_option(buf_id, 'buftype')

  return (uncountable_types[ft] ~= nil and uncountable_types[ft]) or
             (uncountable_types[bt] ~= nil and uncountable_types[bt])
end

--[[
Goto `count` window from left to right, up to bottom. Skip all `uncountable`
filetypes and buftypes.
--]]
function GotoWindow(count)
  function skip_uncountable_windows(cnt)
    local rest = cnt

    for k, win_id in pairs(vim.api.nvim_list_wins()) do
      if not is_uncountable(win_id) then
        rest = rest - 1
        if rest == 0 then
          return win_id
        end
      end
    end

    return 0
  end

  local win_id = skip_uncountable_windows(count)
  if win_id > 0 then
    vim.api.nvim_set_current_win(win_id)
  end
end

-- Jump to file explorer window, open it if not exists before
function JumpToFileExplorer()
  local n = vcall('winnr', {'$'})
  for i = 1, n do
    local win_id = vcall('win_getid', {i})
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = vim.api.nvim_buf_get_option(buf_id, 'ft')

    if tp == 'NvimTree' then
      cmd(i .. 'wincmd w')
      return
    end
  end

  if not require'ht.plugs'.IsLoaded('nvim-tree.lua') then
    require'packer'.loader'nvim-tree.lua'
  end
  require'nvim-tree'.toggle()
end

local function quickfix_window_exists()
  local n = vcall('winnr', {'$'})
  for i = 1, n do
    local win_id = vcall('win_getid', {i})
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = va.nvim_buf_get_option(buf_id, 'buftype')

    if tp == 'quickfix' then return true end
  end

  return false
end

function ToggleQuickfix()
  if quickfix_window_exists() then
    cmd'cclose'
  else
    cmd'copen'
  end
end

function CheckLastWindow()
  local n = vcall('winnr', {'$'})
  local total = n
  for i = 1, n do
    local win_id = vcall('win_getid', {i})
    if is_uncountable(win_id) then total = total - 1 end
  end

  if total == 0 then
    if vim.api.nvim_call_function('tabpagenr', {'$'}) == 1 then
      cmd [[quitall!]]
    else
      cmd [[tabclose]]
    end
  end
end

-- vim: et sw=2 ts=2

