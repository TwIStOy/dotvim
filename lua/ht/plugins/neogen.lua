local M = {}

M.core = { 'danymat/neogen', requires = 'nvim-treesitter/nvim-treesitter' }

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'neogen'.setup {}
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.map({
    keys = { '<leader>', 'n', 'f' },
    action = function()
      require'neogen'.generate()
    end,
    desc = 'generate-doc',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

