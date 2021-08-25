module('ht.plugs.vim_cpp_toolkit', package.seeall)

local set_g_var = vim.api.nvim_set_var
local nmap = require('ht.keymap.keymap').nmap
local cmd = vim.api.nvim_command

function config()
  vim.g.cpp_toolkit_clang_library = vim.g.compiled_llvm_clang_directory

  nmap('<leader>fa', [[:call cpp_toolkit#switch_file_here('')<CR>]],
       {ft = 'cpp', description = 'switch-header-source-here'})
  nmap('<leader>fv',
       [[:call cpp_toolkit#switch_file_here('let curspr=&spr \| set nospr \| vsplit \| wincmd l \| if curspr \| set spr \| endif')<CR>]],
       {ft = 'cpp', description = 'switch-header-source-here'})
  nmap('<leader>cd', [[:call cpp_toolkit#mark_current_function_decl()<CR>]],
       {ft = 'cpp', description = 'copy-func-decl'})
  nmap('<leader>pd', [[:call cpp_toolkit#generate_function_define_here()<CR>]],
       {ft = 'cpp', description = 'paste-func-def'})

  require('ht.core.dropdown').AppendContext('cpp', {
    {
      '&Copy Function Decl\t<leader>cd',
      'call cpp_toolkit#mark_current_function_decl()'
    }, {
      '&Paste Function Def\t<leader>pd',
      'call cpp_toolkit#generate_function_define_here()'
    }
  })
end

-- vim: et sw=2 ts=2

