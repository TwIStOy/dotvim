local M = {}

M.core = { 'AndrewRadev/sideways.vim',
           cmd = { 'SidewaysLeft', 'SidewaysRight' } }

M.setup = function() -- code to run before plugin loaded
  local Menu = require 'nui.menu'
  local menu = require 'ht.core.menu'

  menu:append_section('*', {
    Menu.item('Move Object Left', {
      action = function()
        vim.cmd 'SidewaysLeft'
      end
    }),
    Menu.item('Move Object Right', {
      action = function()
        vim.cmd 'SidewaysRight'
      end
    }),
  })
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

