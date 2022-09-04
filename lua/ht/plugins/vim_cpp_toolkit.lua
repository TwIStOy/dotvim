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

  require('ht.core.dropbox'):append_context('cpp', {
    {
      '&Copy Function Decl\t<leader>cd',
      'call cpp_toolkit#mark_current_function_decl()',
    },
    {
      '&Paste Function Def\t<leader>pd',
      'call cpp_toolkit#generate_function_define_here()',
    },
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

