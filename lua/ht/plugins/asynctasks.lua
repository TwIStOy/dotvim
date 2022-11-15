local M = {}

M.core = {
  'skywind3000/asynctasks.vim',
  cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskProfile', 'AsyncTaskEdit' },
  after = { 'asyncrun.vim' },
  requires = { { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', 'AsyncStop' } } },
}

M.setup = function() -- code to run before plugin loaded
  -- quickfix window height
  vim.g.asyncrun_open = 10
  -- disable bell after finished
  vim.g.asyncrun_bell = 0

  vim.g.asyncrun_rootmarks = {
    'BLADE_ROOT', -- for blade(c++)
    'JK_ROOT', -- for jk(c++)
    'WORKSPACE', -- for bazel(c++)
    '.buckconfig', -- for buck(c++)
    'CMakeLists.txt', -- for cmake(c++)
  }

  vim.g.asynctasks_extra_config = { '~/.dotfiles/dots/tasks/asynctasks.ini' }
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.append_folder_name({ '<leader>', 'b' }, 'build')
  mapping.map {
    keys = { '<leader>', 'b', 'f' },
    action = '<cmd>AsyncTask file-build<CR>',
    desc = 'build-file',
  }
  mapping.map {
    keys = { '<leader>', 'b', 'p' },
    action = '<cmd>AsyncTask project-build<CR>',
    desc = 'build-project',
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

