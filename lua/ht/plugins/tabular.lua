local M = {}

M.core = {
  'junegunn/vim-easy-align',
  cmd = { 'EasyAlign' },
  requires = { { 'godlygeek/tabular', cmd = { 'Tabularize' } } },
}

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'
  mapping.append_folder_name({ 't' }, 'table')
  mapping.map({
    keys = { '<leader>', 't', 'a' },
    action = '<cmd>EasyAlign<CR>',
    desc = 'easy-align',
  })
  mapping.map({
    mode = 'x',
    keys = { '<leader>', 't', 'a' },
    action = '<cmd>EasyAlign<CR>',
    desc = 'easy-align',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

