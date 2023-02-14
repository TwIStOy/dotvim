vim.api.nvim_command [[set runtimepath+=$HOME/.dotvim]]

-- Update this
vim.g.python3_host_prog = '/usr/bin/python3'

-- Update this
vim.g.compiled_llvm_clang_directory = '/home/hawtian/project/llvm/build'

-- Update this
vim.g.lua_language_server_cmd = {
  '/home/hawtian/project/lua-language-server/bin/lua-language-server',
  '-E',
  '/home/hawtian/project/lua-language-server/bin/main.lua',
}

require 'ht.lazy'

