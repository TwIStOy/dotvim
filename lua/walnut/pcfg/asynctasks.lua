module('walnut.pcfg.asynctasks', package.seeall)

local set_g_var = vim.api.nvim_set_var

set_g_var('asyncrun_open', 6)

set_g_var('asyncrun_rootmarks', {
  'BLADE_ROOT', 'JK_ROOT', 'CMakeLists.txt',
})

set_g_var('asynctasks_extra_config', {
  '~/.dotfiles/dots/tasks/asynctasks.ini'
})

