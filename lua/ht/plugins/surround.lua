local M = {}

M.core = { 'tpope/vim-surround', opt = true }

M.setup = function() -- code to run before plugin loaded
  vim.g.surround_no_mappings = 0
  vim.g.surround_no_insert_mappings = 1

  vim.defer_fn(function()
    vim.cmd([[pa vim-surround]])
  end, 500)
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M
-- vim: et sw=2 ts=2 fdm=marker

