dotvim
======

## Prerequisites

- [neovim nightly](https://github.com/neovim/neovim)
- nodejs & yarn
- python module: pynvim
- node package: neovim

## Setup

```
$ ln -s /path/to/dotvim ~/.dotvim
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.lua ~/.config/nvim/init.lua
```

Update `vim.g.python3_host_prog = '/usr/local/bin/python3'` in `~/.config/nvim/init.lua` to the result of `which python3`.
Update `vim.g.compiled_llvm_clang_directory` to where you installed llvm and clang.

## Default Key Mappings
### Leader
| Mapping | Function                  |
| ---     | ---                       |
| 1       | 1st window                |
| 2       | 2nd window                |
| 3       | 3rd window                |
| 4       | 4rd window                |
| 5       | 5th window                |
| 6       | 6th window                |
| 7       | 7th window                |
| 8       | 8th window                |
| 9       | 9th window                |
| e       | edit file pwd             |
| fc      | format file               |
| fs      | save buffer               |
| ft      | toggle file explorer      |
| lo      | list outline              |
| q       | quit                      |
| x       | save and quit             |
| wv      | split window vertical     |
| w-      | split window horizontal   |
| w=      | balance window            |
| wr      | rotate window rightwards  |
| wx      | exchange window with next |
| Q       | force quit                |

### Normal
| Mapping            | Function                                   |
| ---                | ---                                        |
| F3                 | toggle file explorer                       |
| F4                 | list all buffers                           |
| tq                 | toggle quickfix window                     |
| M-n                | clear all highlight                        |
| M-h                | move cursor to window left of current one  |
| M-j                | move cursor to window below current one    |
| M-k                | move cursor to window above current one    |
| M-l                | move cursor to window right of current one |
| M-,                | previous buffer                            |
| M-.                | next buffer                                |
| ;;                 | open dropdown context menu                 |
| \<Space\>\<Space\> | open title menu                            |


