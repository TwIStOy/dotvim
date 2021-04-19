module('walnut.settings', package.seeall)

-- all autocmds waiting for https://github.com/neovim/neovim/pull/12378
-- to register autocmd in lua natively

local va = vim.api
local cmd = vim.api.nvim_command
local keymap = va.nvim_set_keymap
local setopt = va.nvim_set_option

cmd [[autocmd VimEnter * if !argc() | silent! Startify | endif]]

cmd [[autocmd BufEnter * lua require('walnut.keymap').define_keymap_here()]]

va.nvim_set_var('mapleader', ' ')

-- Disable arrows
keymap('', '<Left>', '<Nop>', {})
keymap('', '<Right>', '<Nop>', {})
keymap('', '<Up>', '<Nop>', {})
keymap('', '<Down>', '<Nop>', {})

-- nvim_set_option does not affect first window, use orginal `set` command instead

-- setopt('title', true)
-- setopt('ttyfast', true)
cmd[[set title ttyfast]]

-- setopt('termguicolors', true)
cmd[[set nolazyredraw termguicolors]]

--setopt('pumblend', 40)
cmd[[set pumblend=40]]

-- no bells
cmd[[set noerrorbells novisualbell t_vb=]]

-- numbers
-- setopt('number', true)
-- setopt('relativenumber', true)
cmd[[set nu]]
cmd[[set relativenumber]]

-- cursorline autocmd
cmd[[set cursorline]]
cmd('autocmd InsertLeave,WinEnter * set cursorline')
cmd('autocmd InsertEnter,WinLeave * set nocursorline')

-- edit settings
-- setopt('expandtab', true)
-- setopt('smartindent', true)
-- setopt('autoindent', true)
cmd[[set expandtab smartindent autoindent]]

-- default tab width: 2
-- setopt('tabstop', 2)
-- setopt('shiftwidth', 2)
cmd[[set tabstop=2 shiftwidth=2]]

-- setopt('cmdheight', 2)
cmd('set noshowmode cmdheight=2')

setopt('exrc', true)

-- move quickfix windows to botright automatically
cmd('autocmd FileType qf wincmd J')

-- default colorcolumn: 80
-- setopt('colorcolumn', '80')
cmd[[set colorcolumn=80]]

-- setopt('scrolloff', 5)
cmd[[set scrolloff=5]]

--setopt('timeoutlen', 300)
cmd[[set timeoutlen=300]]

cmd[[set signcolumn=yes]]

-- skip specify types when switching windows
local ww = require('walnut.window')
ww.skip_type('quickfix')
ww.skip_type('defx')
ww.skip_type('CHADTree')
ww.skip_type('NvimTree')

cmd [[au BufEnter * lua require('walnut.window').check_last_window() ]]

local ftmap = require('walnut.keymap').ftmap
local ftdesc_folder = require('walnut.keymap').ftdesc_folder

keymap('n', '<F3>', [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]], { silent = true, noremap = true })
keymap('n', '<F4>', ':call quickui#tools#list_buffer("e")<CR>', { silent = true, noremap = true })
keymap('n', ';;',
       [[:lua require('walnut.pcfg.quickui').open_dropdown_menu(vim.api.nvim_get_option('ft'))<CR>]],
       { silent = true, noremap = true })

ftdesc_folder('*', 'w', 'window')

for i = 1, 9 do
  ftmap('*', 'Window ' .. i, '' .. i, [[:lua require('walnut.window').goto_win(]] .. i .. ')<CR>')
end

ftdesc_folder('*', 'f', 'file')
ftmap('*', 'update', 'fs', ':update<CR>')
ftmap('*', 'toggle-file-explorer', 'ft',
  [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]])

keymap('n', '*', '<Plug>(quickhl-manual-this-whole-word)', { silent = true })
keymap('n', 'n', '<Plug>(quickhl-manual-go-to-next)', { silent = true })
keymap('n', 'N', '<Plug>(quickhl-manual-go-to-prev)', { silent = true })
keymap('n', '<M-n>', [[:nohl<CR>:QuickhlManualReset<CR>]], { silent = true, noremap = true })
keymap('v', '*', '<Plug>(quickhl-manual-this)', { silent = true})

ftmap('*', 'quit', 'q', ':q<CR>')
ftmap('*', 'save-and-quit', 'x', ':wq<CR>')
ftmap('*', 'quit-all', 'Q', ':confirm qall<CR>')

keymap('n', 'tq', [[:lua require('walnut.window').toggle_quickfix()<CR>]], { silent = true, noremap = true })

ftdesc_folder('w', 'win')
ftmap('*', 'split-window-vertical', 'wv',':wincmd v<CR>')
ftmap('*', 'split-window-horizontal', 'w-',':wincmd s<CR>')
ftmap('*', 'balance-window', 'w=',':wincmd =<CR>')
ftmap('*', 'rotate-window-rightwards', 'wr', ':wincmd r<CR>')
ftmap('*', 'exchange-window-with-next', 'wx', ':wincmd x<CR>')

keymap('n', '<M-h>', ':wincmd h<CR>', { silent = true, noremap = true })
keymap('n', '<M-j>', ':wincmd j<CR>', { silent = true, noremap = true })
keymap('n', '<M-k>', ':wincmd k<CR>', { silent = true, noremap = true })
keymap('n', '<M-l>', ':wincmd l<CR>', { silent = true, noremap = true })

keymap('n', '<leader>', [[:WhichKey '<Space>'<CR>]], { silent = true, noremap = true })

if vim.g['fvim_loaded'] == nil then
  -- setopt('wildoptions', 'pum')
  cmd[[set wildoptions=pum]]
end

