module('walnut.pcfg.coc', package.seeall)

local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder
local cmd = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

function setup()
  vim.g.coc_start_at_startup = 0
  vim.api.nvim_set_option('updatetime', 200)
end

function config()
  cmd [[au CursorHoldI,CursorMovedI * silent! call CocActionAsync('showSignatureHelp')]]
  cmd [[au! CompleteDone * if pumvisible() == 0 | pclose | endif ]]

  cmd [[source ~/.dotvim/pcfg/coc.vim]]
end


