module('walnut.pcfg.nvim_tree', package.seeall)

local va = vim.api

vim.api.nvim_set_var('nvim_tree_ignore', {
  '.git', 'node_modules', '.cache',
  '.build'
})

vim.api.nvim_set_var('nvim_tree_auto_open', 1)

vim.api.nvim_set_var('nvim_tree_git_hl', 1)

