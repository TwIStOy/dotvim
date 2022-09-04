local M = {}

M.core = {
  't9md/vim-quickhl',
  cmd = { 'QuickhlManualReset' },
  fn = { 'quickhl#*' },
}

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'
  mapping.map {
    keys = { '*' },
    action = [[<cmd>call quickhl#manual#this_whole_word('n')<CR>]],
  }
  mapping.map {
    keys = { 'n' },
    action = [[<cmd>call quickhl#manual#go_to_next('s')<CR>]],
  }
  mapping.map {
    keys = { 'N' },
    action = [[<cmd>call quickhl#manual#go_to_prev('s')<CR>]],
  }
  mapping.map {
    keys = { '<M-n>' },
    action = [[:nohl<CR>:QuickhlManualReset<CR>]],
  }

  mapping.map {
    mode = 'v',
    keys = '*',
    action = [[<cmd>call quickhl#manual#this('v')<CR>]],
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

