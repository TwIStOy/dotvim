module('walnut.pcfg.asynctasks', package.seeall)

function setup()
  vim.g.asyncrun_open = 10
  vim.g.asyncrun_bell = 0

  vim.g.asyncrun_exit =
      [[silent lua require('walnut.pcfg.asynctasks').cmd_finish()]]

  vim.g.asyncrun_rootmarks = {'BLADE_ROOT', 'JK_ROOT', 'CMakeLists.txt'}

  vim.g.asynctasks_extra_config = {'~/.dotfiles/dots/tasks/asynctasks.ini'}
end

function cmd_finish()
  vim.notify("Job:\n" .. vim.g.asyncrun_cmd .. "\nfinished.", "info", {title = "Async", timeout = 10000})
end
