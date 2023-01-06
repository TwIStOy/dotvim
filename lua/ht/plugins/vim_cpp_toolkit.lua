local M = {}

M.core = {
  'TwIStOy/vim-cpp-toolkit',
  fn = { 'cpp_toolkit#*' },
  opt = true,
  requires = { 'Yggdroot/LeaderF' },
  wants = 'LeaderF',
  after = 'LeaderF',
}

M.config = function() -- code to run after plugin loaded
  vim.g.cpp_toolkit_clang_library = vim.g.compiled_llvm_clang_directory
  local Menu = require 'nui.menu'
  local menu = require 'ht.core.menu'

  menu:append_section('cpp', {
    Menu.item('Copy Function Decl', {
      action = function()
        vim.cmd 'call cpp_toolkit#mark_current_function_decl()'
      end
    }),
    Menu.item('Paste Function Def', {
      action = function()
        vim.cmd 'call cpp_toolkit#generate_function_define_here()'
      end
    }),
  })
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.ft_map('cpp', {
    keys = { '<leader>', 'f', 'a' },
    action = [[:call cpp_toolkit#switch_file_here('')<CR>]],
    desc = 'switch-header-source-here',
  })
end

return M

-- vim: et sw=2 ts=2 fdm=marker

