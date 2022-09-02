local M = {}

M.core = {
  'kana/vim-textobj-user',
  opt = true,
  requires = {
    { 'lucapette/vim-textobj-underscore', opt = true,
      after = 'vim-textobj-user' },
    { 'sgur/vim-textobj-parameter', opt = true, after = 'vim-textobj-user' },
  },
}

M.setup = function() -- code to run before plugin loaded
  vim.defer_fn(function()
    require'packer'.loader('vim-textobj-user')
  end, 1000)
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

