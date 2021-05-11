module('walnut.pcfg.coc', package.seeall)

local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder
local cmd = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

function setup()
  vim.g.coc_start_at_startup = 1
  vim.api.nvim_set_option('updatetime', 200)

  require('walnut.pcfg.quickui').append_context_menu_section('cpp', {
    { 'Goto &Definition\tgd', [[call feedkeys("\<Plug>(coc-definition)")]] },
    { 'Goto &Type Definition', [[call feedkeys("\<Plug>(coc-type-definition)")]] },
    { 'Goto &Implementation', [[call feedkeys("\<Plug>(coc-implementation)")]] },
    { '&Rename', [[call feedkeys("\<Plug>(coc-rename)")]] },
    { 'Code &Action\tga', [[call feedkeys("\<Plug>(coc-codeaction)")]] },
    { 'List &Outline\t', [[:<C-u>CocList outline]] },
  })
end

function config()
  cmd [[autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]

  cmd [[au! CompleteDone * if pumvisible() == 0 | pclose | endif ]]

  ftdesc_folder('*', 'l', 'list')
  ftmap('*', 'list-outline', 'lo', ':<C-u>CocList outline<cr>')

  cmd [[source ~/.dotvim/pcfg/coc.vim]]
end

