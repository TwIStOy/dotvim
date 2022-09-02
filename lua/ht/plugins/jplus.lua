local M = {}

M.core = { 'osyo-manga/vim-jplus' }

M.setup = function() -- code to run before plugin loaded
  vim.defer_fn(function()
    require'packer'.loader('vim-jplus')
  end, 800)
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.map { keys = { 'J' }, action = '<Plug>(jplus)', noremap = false }

  mapping.map {
    mode = 'v',
    keys = { 'J' },
    action = '<Plug>(jplus)',
    noremap = false,
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

