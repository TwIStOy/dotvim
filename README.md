dotvim
======

## Prerequisites

- [neovim](https://github.com/neovim/neovim)
- nodejs & yarn
- python module: pynvim
- node package: neovim

## Setup

```
$ ln -s /path/to/dotvim ~/.dotvim
$ cp ~/.dotvim/dotvim.toml ~/.dotvim.toml
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.vim ~/.config/nvim/init.vim
```

Update `let g:python3_host_prog = '/usr/local/bin/python3'` in `~/.config/nvim/init.vim` to the result of `which python3`.


