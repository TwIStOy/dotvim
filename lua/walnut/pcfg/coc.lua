module('walnut.pcfg.coc', package.seeall)

local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder
local cmd = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

function setup()
  vim.g.coc_start_at_startup = 1
  vim.api.nvim_set_option('updatetime', 200)
end

function config()
  cmd [[autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]

  cmd [[au! CompleteDone * if pumvisible() == 0 | pclose | endif ]]

  ftdesc_folder('*', 'l', 'list')
  ftmap('*', 'list-outline', 'lo', ':<C-u>CocList outline<cr>')

  cmd [[source ~/.dotvim/pcfg/coc.vim]]

  vim.api.nvim_call_function('quickui#menu#install', {
    '&LSP', {
      { 'Start', 'CocStart' },
      { '&Restart', 'CocRestart' },
      { 'Enable', 'CocEnable' },
      { 'Disable', 'CocDisable' },
      { '--', '' },
      { 'List &Outlines', 'CocList outline' },
      { 'List &Diagnostics', 'CocList diagnostics' }
    }
  })
end


