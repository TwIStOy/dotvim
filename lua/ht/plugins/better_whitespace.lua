local M = {}

M.core = {
  'ntpeters/vim-better-whitespace',
  keys = { '_s' },
  cmd = {
    'StripWhitespace',
    'EnableStripWhitespaceOnSave',
    'DisableStripWhitespaceOnSave',
    'ToggleStripWhitespaceOnSave',
    'EnableWhitespace',
    'DisableWhitespace',
    'ToggleWhitespace',
  },
}

M.setup = function() -- code to run before plugin loaded
  vim.g.better_whitespace_operator = '_s'
  vim.g.better_whitespace_filetypes_blacklist = {
    'diff',
    'git',
    'gitcommit',
    'unite',
    'qf',
    'help',
    'markdown',
    'fugitive',
    -- above are default filetypes
    'which_key',
  }
end

M.config = function() -- code to run after plugin loaded
  local event = require 'ht.core.event'

  event.on('BufRead', {
    pattern = '/usr/src/linux*',
    callback = function()
      vim.cmd 'DisableStripWhitespaceOnSave'
      vim.cmd 'DisableWhiteSpace'
    end,
  })
end

M.mappings = function() -- code for mappings
  local mapping = require "ht.core.mapping"
  mapping.map { keys = { '_', 's' }, desc = 'strip-whitespace' }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

