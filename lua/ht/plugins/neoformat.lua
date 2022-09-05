local M = {}

M.core = { 'sbdchd/neoformat', event = 'BufRead' }

M.setup = function() -- code to run before plugin loaded
  vim.g.neoformat_only_msg_on_error = 1
  vim.g.neoformat_basic_format_align = 1
  vim.g.neoformat_basic_format_retab = 1
  vim.g.neoformat_basic_format_trim = 1
end

M.config = function() -- code to run after plugin loaded
  local dropbox = require 'ht.core.dropbox'

  vim.cmd [[source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim]]
  vim.g._dotvim_clang_format_exe = vim.g.compiled_llvm_clang_directory ..
                                       '/bin/clang-format'
  vim.g.neoformat_enabled_cpp = { 'myclangformat' }

  dropbox:append_context('*', { { 'Format', 'Neoformat' } })

  vim.g.neoformat_rust_rustfmt2 = { exe = "rustfmt", args = {}, stdin = 1 }
  vim.g.neoformat_enabled_rust = { 'rustfmt2' }
  vim.g.neoformat_enabled_lua = { 'luaformat' }
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'
  mapping.map {
    keys = { '<leader>', 'f', 'c' },
    action = '<cmd>Neoformat<CR>',
    desc = 'format-file',
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

