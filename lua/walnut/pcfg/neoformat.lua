module('walnut.pcfg.neoformat', package.seeall)

function setup()
  vim.g.neoformat_only_msg_on_error = 1
  vim.g.neoformat_basic_format_align = 1
  vim.g.neoformat_basic_format_retab = 1
  vim.g.neoformat_basic_format_trim = 1
end

function config()
  local quickui = require 'walnut.pcfg.quickui'

  vim.cmd [[source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim]]
  vim.g._dotvim_clang_format_exe = vim.g.compiled_llvm_clang_directory ..
                                       '/bin/clang-format'
  vim.g.neoformat_enabled_cpp = {'myclangformat'}

  require('walnut.keymap').ftmap('*', 'format-file', 'fc', ':<C-u>Neoformat<CR>')
  quickui.append_context_menu_section('*', {{'Format', 'Neoformat'}})

  vim.g.neoformat_rust_rustfmt2 = {exe = "rustfmt", args = {}, stdin = 1}
  vim.g.neoformat_enabled_rust = {'rustfmt2'}

  vim.g.neoformat_enabled_lua = {'luaformat'}
end

