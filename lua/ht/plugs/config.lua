module('ht.plugs.config', package.seeall)

function asynctasks_setup()
  vim.g.asyncrun_open = 6
  vim.g.asyncrun_rootmarks = {
    'BLADE_ROOT', 'JK_ROOT', 'CMakeLists.txt',
  }
  vim.g.asynctasks_extra_config = {
    '~/.dotfiles/dots/tasks/asynctasks.ini'
  }
end



