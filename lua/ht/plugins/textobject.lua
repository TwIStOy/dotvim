local M = {}

M.core = {
  'kana/vim-textobj-user',
  opt = true,
  requires = {
    { 'lucapette/vim-textobj-underscore', opt = true,
      wants = 'vim-textobj-user',
      after = 'vim-textobj-user'
    },
    { 'sgur/vim-textobj-parameter', opt = true,
    wants = 'vim-textobj-user',
    after = 'vim-textobj-user'
  },
  },
}

M.setup = function() -- code to run before plugin loaded
  vim.defer_fn(function()
    require'packer'.loader('vim-textobj-user')
  end, 1000)
end

return M

-- vim: et sw=2 ts=2 fdm=marker

