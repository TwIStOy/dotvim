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

## Default Key Mappings
### Leader
| Mapping | Function |
| --- | --- |
| 1 | 1st window |
| 2 | 2nd window |
| 3 | 3rd window |
| 4 | 4rd window |
| 5 | 5th window |
| 6 | 6th window |
| 7 | 7th window |
| 8 | 8th window |
| 9 | 9th window |
| fs | save buffer |
| ft | toggle file explorer |
| q | quit |
| x | save and quit |
| wv | split window vertical |
| w- | split window horizontal |
| w= | balance window |
| wr | rotate window rightwards |
| wx | exchange window with next |
| Q | force quit |

### Normal
| Mapping | Function |
| --- | --- |
| F3 | toggle file explorer |
| F4 | list all buffers |
| tq | toggle quickfix window |
| M-n | clear all highlight |
| M-h | move cursor to window left of current one |
| M-j | move cursor to window below current one |
| M-k | move cursor to window above current one |
| M-l | move cursor to window right of current one |

## FileType Mappings

