local M = {}

M.core = { 'tomtom/tcomment_vim', event = 'BufReadPost' }

M.setup = function() -- code to run before plugin loaded
  vim.g.tcomment_maps = 0
  vim.schedule(function()
    require'packer'.loader('tcomment_vim')
  end)
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.map({
    keys = { 'g', 'c', 'c' },
    action = '<cmd>TComment<CR>',
    desc = 'toggle-comment',
  })

  mapping.map({
    mode = 'v',
    keys = { 'g', 'c', 'c' },
    action = ':TCommentBlock<CR>',
    desc = 'toggle-comment',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

