<h1 align="center">dotvim</h1>

<p align="center">
    <a href="https://github.com/TwIStOy/dotvim/pulse">
      <img src="https://img.shields.io/github/last-commit/TwIStOy/dotvim?style=for-the-badge&logo=github&color=7dc4e4&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
    <a href="https://github.com/TwIStOy/dotvim/blob/main/LICENSE">
      <img alt="License" src="https://img.shields.io/github/license/TwIStOy/dotvim?style=for-the-badge&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/TwIStOy/dotvim/stargazers">
      <img src="https://img.shields.io/github/stars/TwIStOy/dotvim?style=for-the-badge&logo=apachespark&color=eed49f&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
    <a href="https://github.com/TwIStOy/dotvim">
      <img alt="Repo Size" src="https://img.shields.io/github/repo-size/TwIStOy/dotvim?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41" />
    </a>
</p>

![](https://raw.githubusercontent.com/TwIStOy/dotvim/master/screenshots/start_page.png)

## Prerequisites

- [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
- [Neovim 0.9+ (nightly is better)](https://github.com/neovim/neovim)
- Terminal with true color support
- Optional Requirements:
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [fd](https://github.com/sharkdp/fd)
  - [delta](https://github.com/dandavison/delta)
  - [bat](https://github.com/sharkdp/bat)

## Installation

```
$ ln -s /path/to/dotvim ~/.dotvim
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.lua ~/.config/nvim/init.lua
```

- Update `vim.g.python3_host_prog = '/usr/local/bin/python3'` in `~/.config/nvim/init.lua` to the result of `which python3`.
- Update `vim.g.rime_ls_cmd` to where you installed [rime_ls](https://github.com/wlh320/rime-ls).
