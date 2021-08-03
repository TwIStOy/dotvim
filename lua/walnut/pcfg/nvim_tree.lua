module('walnut.pcfg.nvim_tree', package.seeall)

local va = vim.api

vim.api.nvim_set_var('nvim_tree_git_hl', 1)

vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_ignore = {'.git', 'node_modules', '.cache', '.build'}
vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_quit_on_open = 1

