local M = {}

M.requires = function() -- return required packages
end

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
end

M.mappings = function() -- code for mappings
  return {
    default = { -- pass to vim.api.nvim_set_keymap
    },
    wk = { -- send to which-key
    },
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

