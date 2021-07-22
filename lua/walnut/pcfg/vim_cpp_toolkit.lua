module('walnut.pcfg.vim_cpp_toolkit', package.seeall)

local set_g_var = vim.api.nvim_set_var
local ftmap = require('walnut.keymap').ftmap
local cmd = vim.api.nvim_command

vim.g.cpp_toolkit_clang_library = vim.g.compiled_llvm_clang_directory

ftmap('cpp', 'switch-header-source-here', 'fa',
      [[:call cpp_toolkit#switch_file_here('')<CR>]])
ftmap('cpp', 'switch-header-source-here', 'fv',
      [[:call cpp_toolkit#switch_file_here('let curspr=&spr \| set nospr \| vsplit \| wincmd l \| if curspr \| set spr \| endif')<CR>]])
ftmap('cpp', 'copy-func-decl', 'cd',
      [[:call cpp_toolkit#mark_current_function_decl()<CR>]])
ftmap('cpp', 'paste-func-def', 'pd',
      [[:call cpp_toolkit#generate_function_define_here()<CR>]])

require('walnut.pcfg.quickui').append_context_menu_section('cpp', {
  {
    '&Copy Function Decl\t<leader>cd',
    'call cpp_toolkit#mark_current_function_decl()'
  }, {
    '&Paste Function Def\t<leader>pd',
    'call cpp_toolkit#generate_function_define_here()'
  }
})

if not _G.packer_plugins['LeaderF'].loaded then
  require('packer').loader('LeaderF')
end

--[[
vim.api.nvim_command [[
let g:templates_user_variables = get(g:, 'templates_user_variables', [])

call add(g:templates_user_variables, [ 'PROJECT_HEADER', 'cpp_toolkit#fast_include_header_file' ])
]]
--]]

