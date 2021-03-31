module('walnut.pcfg.template', package.seeall)

local set_g_var = vim.api.nvim_set_var
local get_opt = vim.api.nvim_get_option
local ftmap = require('walnut.keymap').ftmap
local keymap = vim.api.nvim_set_keymap

set_g_var('templates_directory', { os.getenv('HOME') .. [[/.dotvim/vim-templates]] })
set_g_var('templates_no_autocmd', 0)
set_g_var('templates_debug', 0)
set_g_var('templates_no_builtin_templates', 1)

-- TODO(hawtian):
-- let g:templates_user_variables = get(g:, 'templates_user_variables', [])
-- call extend(g:templates_user_variables, [
--       \   [ 'GIT_USER',  'dotvim#utils#git_user' ],
--       \   [ 'GIT_EMAIL', 'dotvim#utils#git_email' ],
--       \   [ 'LAST_FOLDER', 'dotvim#crate#better#_last_folder_name' ],
--       \ ])
--
