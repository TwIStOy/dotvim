local M = {}

M.core = { 'ethanholz/nvim-lastplace' }

M.config = function() -- code to run after plugin loaded
  require'nvim-lastplace'.setup {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = false,
  }
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

