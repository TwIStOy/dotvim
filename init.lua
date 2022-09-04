vim.api.nvim_command [[set runtimepath+=$HOME/.dotvim]]
vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.compiled_llvm_clang_directory = '/home/hawtian/project/llvm/build'

pcall(function()
  require'packer_compiled'
end)
require'ht.init'


