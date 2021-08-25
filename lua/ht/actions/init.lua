module('ht.actions', package.seeall)

local file = require 'ht.actions.file'
local call = vim.api.nvim_call_function

OpenProjectRoot = file.OpenProjectRoot

local menu_initialized = false
function OpenMenu()
  require'ht.plugs.quickui'.update_color()

  if not menu_initialized then
    require'ht.conf.menu'.SetupMenuItems()
  end

  call('quickui#menu#open', {})
end

-- vim: et sw=2 ts=2 fdm=marker

