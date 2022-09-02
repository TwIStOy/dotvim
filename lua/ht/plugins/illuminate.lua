local M = {}

M.core = { 'RRethy/vim-illuminate', opt = true }

M.setup = function() -- code to run before plugin loaded
  vim.defer_fn(function()
    vim.cmd [[pa vim-illuminate]]

  end, 300)

  vim.g.Illuminate_delay = 200
  vim.g.Illuminate_ftblacklist = { 'nerdtree', 'defx' }
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

