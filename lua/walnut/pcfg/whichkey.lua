module('walnut.pcfg.whichkey', package.seeall)

local set_g_var = vim.api.nvim_set_var

set_g_var('which_key_use_floating_win', 1)
set_g_var('which_key_floating_relative_win', 1)
set_g_var('which_key_centered', 0)

vim.api.nvim_call_function('which_key#register', {'<Space>', 'b:which_key_map'})

vim.cmd [[hi WhichKeyFloating guibg=NONE]]

vim.g.which_key_floating_opts = {row = -2}

