local M = {}

M.core = { 'TwIStOy/conflict-resolve.nvim', fn = 'conflict_resolve#*' }

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.append_folder_name({ 'v' }, 'vcs')
  mapping.map({
    keys = { '<leader>', 'v', '1' },
    action = '<cmd>call conflict_resolve#ourselves()<CR>',
    desc = 'select-ours',
  })
  mapping.map({
    keys = { '<leader>', 'v', '2' },
    action = '<cmd>call conflict_resolve#themselves()<CR>',
    desc = 'select-them',
  })
  mapping.map({
    keys = { '<leader>', 'v', 'b' },
    action = '<cmd>call conflict_resolve#both()<CR>',
    desc = 'select-both',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

