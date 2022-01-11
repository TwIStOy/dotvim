module('ht.plugs.coc', package.seeall)

local cmd = vim.api.nvim_command
local help_types = {vim = 1, help = 1}
local nmap = require('ht.keymap.keymap').nmap
local SetFolderName = require('ht.keymap.keymap').SetFolderName

function ShowDocumentation()
  local ft = vim.api.nvim_buf_get_option(0, '&ft')
  if help_types[ft] ~= nil then
    cmd('h ' .. vim.fn.expand {'<cword>'})
    return
  end

  if vim.fn['coc#rpc#ready'] {} then
    vim.fn['CocActionAsync'] {'doHover'}
    return
  end

  cmd [[execute '!' . &keywordprg . ' ' . expand('<cword>')]]
end

function config()
  require('ht.core.dropdown').AppendContext('cpp', {
    {'Goto &Definition\tgd', [[call feedkeys("\<Plug>(coc-definition)")]]},
    {'Goto &Type Definition', [[call feedkeys("\<Plug>(coc-type-definition)")]]},
    {'Goto &Implementation', [[call feedkeys("\<Plug>(coc-implementation)")]]},
    {'Goto &Reference', [[call feedkeys("\<Plug>(coc-reference)")]]},
    {'Rename', [[call feedkeys("\<Plug>(coc-rename)")]]},
    {'Code &Action\tga', [[call feedkeys("\<Plug>(coc-codeaction)")]]},
    {'List &Outline\t', [[:<C-u>CocList outline]]}
  })

  cmd [[autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')]]

  cmd [[au! CompleteDone * if pumvisible() == 0 | pclose | endif ]]

  SetFolderName('*', 'l', 'list')
  nmap('<leader>lo', ':<C-u>CocList outline<cr>', {description = 'list-outline'})

  cmd [[source ~/.dotvim/pcfg/coc.vim]]
end

function setup()
  vim.g.coc_start_at_startup = 1
  vim.g.coc_snippet_next = "<C-f>"
  vim.g.coc_snippet_prev = "<C-b>"

  vim.g.coc_global_extensions = {
    'coc-vimlsp', 'coc-tabnine', 'coc-tsserver', 'coc-rust-analyzer',
    'coc-pyright', 'coc-json', 'coc-clangd', 'coc-clang-format-style-options'
  }
end

-- vim: et sw=2 ts=2

