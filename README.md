# dotvim

<p align="center">
    <a href="https://github.com/TwIStOy/dotvim/pulse">
      <img src="https://img.shields.io/github/last-commit/TwIStOy/dotvim?style=for-the-badge&logo=github&color=7dc4e4&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
</p>

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
Update `vim.g.rime_ls_cmd` to where you installed [rime_ls](https://github.com/wlh320/rime-ls).

---
