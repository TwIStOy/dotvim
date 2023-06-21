dotvim
======

![](https://raw.githubusercontent.com/TwIStOy/dotvim/master/screenshots/start_page.png)

## Prerequisites

- [neovim nightly](https://github.com/neovim/neovim)

## Setup

```
$ ln -s /path/to/dotvim ~/.dotvim
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.lua ~/.config/nvim/init.lua
```

Update `vim.g.python3_host_prog = '/usr/local/bin/python3'` in `~/.config/nvim/init.lua` to the result of `which python3`.  
Update `vim.g.compiled_llvm_clang_directory` to where you installed [llvm and clang](https://github.com/llvm/llvm-project).  
Update `vim.g.rime_ls_cmd` to where you installed [rime_ls](https://github.com/wlh320/rime-ls).  

---
