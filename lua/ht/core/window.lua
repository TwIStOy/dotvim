module('ht.core.window', package.seeall)

-- uncountable filetypes and buftypes which will be ignored in window counting.
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
      if uncountable_types(win_id) then
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

-- vim: et sw=2 ts=2

