local M = {}

M.core = {
  'p00f/cphelper.nvim',
  requires = 'nvim-lua/plenary.nvim',
  cmd = { 'CphReceive', 'CphTest', 'CphRetest', 'CphEdit', 'CphDelete' },
}

M.setup = function() -- code to run before plugin loaded
  vim.g['cph#dir'] = '/Users/hawtian/Projects/competitive-programming'
  vim.g['cph#lang'] = 'rust'
  vim.g['cph#rust#createjson'] = true

  local mapping = require 'ht.core.mapping'
  mapping.map {
    mode = 'n',
    keys = { '<F9>' },
    action = '<cmd>CphTest<CR>',
    desc = 'Run cp test',
  }
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

