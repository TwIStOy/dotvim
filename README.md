dotvim
======

## Prerequisites

- [neovim nightly](https://github.com/neovim/neovim)
- python module: pynvim, regex, pygments

## Setup

```
$ ln -s /path/to/dotvim ~/.dotvim
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.lua ~/.config/nvim/init.lua
```

Update `vim.g.python3_host_prog = '/usr/local/bin/python3'` in `~/.config/nvim/init.lua` to the result of `which python3`.  
Update `vim.g.compiled_llvm_clang_directory` to where you installed llvm and clang.  
Update `vim.g.lua_language_server_cmd` to where you installed lua_language_server.

---
