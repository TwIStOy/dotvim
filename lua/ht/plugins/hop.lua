local M = {}

M.core = {
  'phaazon/hop.nvim',
  cmd = {
    'HopWord',
    'HopPattern',
    'HopChar1',
    'HopChar2',
    'HopLine',
    'HopLineStart',
  },
}

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

