vim.api.nvim_command([[set runtimepath+=$HOME/.dotvim]])

-- Update this
vim.g.python3_host_prog = "/usr/bin/python3"

-- Update this
vim.g.compiled_llvm_clang_directory = "/home/hawtian/project/llvm/build"

-- Update this
vim.g.lua_language_server_cmd = {
  "/home/hawtian/project/lua-language-server/bin/lua-language-server",
  "-E",
  "/home/hawtian/project/lua-language-server/bin/main.lua",
}

-- Add luarocks path
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?.lua;"
package.cpath = package.cpath
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/lib/lua/5.1/?.so;"

-- Update this
vim.g.rime_ls_cmd = { "/home/hawtian/project/rime-ls/target/release/rime_ls" }

require("ht.init")
