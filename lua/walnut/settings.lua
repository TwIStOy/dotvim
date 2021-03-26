module('walnut.settings', package.seeall)

-- all autocmds waiting for https://github.com/neovim/neovim/pull/12378
-- to register autocmd in lua natively

local va = vim.api
local cmd = vim.api.nvim_command
local keymap = va.nvim_set_keymap
local setopt = va.nvim_set_option

cmd('autocmd VimEnter * if !argc() | silent! Startify | endif')

-- Disable arrows
keymap('', '<Left>', '<Nop>')
keymap('', '<Right>', '<Nop>')
keymap('', '<Up>', '<Nop>')
keymap('', '<Down>', '<Nop>')

setopt('title', true)
setopt('ttyfast', true)

setopt('nolazyredraw', true)
setopt('termguicolors', true)

setopt('pumblend', 40)

-- no bells
setopt('noerrorbells', true)
setopt('novisualbell', true)
setopt('t_vb', '')

-- numbers
setopt('number', true)
setopt('relativenumber', true)

-- cursorline autocmd
cmd('autocmd InsertLeave,WinEnter * set cursorline')
cmd('autocmd InsertEnter,WinLeave * set nocursorline')

-- edit settings
setopt('expandtab', true)
setopt('smartindent', true)
setopt('autoindent', true)

-- default tab width: 2
setopt('tabstop', 2)
setopt('shiftwidth', 2)

setopt('cmdheight', 2)
setopt('noshowmode', true)

setopt('exrc', true)

-- move quickfix windows to botright automatically
cmd('autocmd FileType qf wincmd J')

-- default colorcolumn: 80
setopt('colorcolumn', 80)

setopt('scrolloff', 5)

setopt('timeoutlen', 300)

-- skip specify types when switching windows
local ww = require('walnut.window')
ww.skip_type('quickfix')
ww.skip_type('defx')
ww.skip_type('CHADTree')
ww.skip_type('NvimTree')

keymap('n', '<F3>', [[:lua require('walnut.window').fast_forward_to_file_explorer()<CR>]], { silent = true, noremap = true })
keymap('n', '<F4>', ':call quickui#tools#list_buffer("e")<CR>', { silent = true, noremap = true })
keymap('n', ';;', [[:lua require('walnut.config.quickui').open_dropdown_menu()<CR>]], { silent = true, noremap = true })

for i = 1, 9 do
  keymap('n', '<leader>' .. i, [[ :lua require('walnut.window').goto_win(]] .. i .. ')', { silent = true, noremap = true })
end

  -- " default keybindings {{{
  -- for l:i in range(1, 9)
  --   call dotvim#mapping#define_leader('nnoremap',
  --         \ string(l:i),
  --         \ ':call dotvim#api#window#get().move_to(' .  l:i. ')<CR>',
  --         \ 'Window ' . l:i)
  -- endfor
  --
  -- call dotvim#mapping#define_name('f', '+file')
  -- call dotvim#mapping#define_leader('nnoremap', 'fs',
  --       \ ':update<CR>', 'save')
  --
  -- call dotvim#mapping#define_leader('nnoremap', 'ft',
  --       \ ':NvimTreeToggle<CR>', 'toggle-file-explorer')
  --
  -- call dotvim#mapping#define_name('j', '+jump')
  -- call dotvim#mapping#define_leader('nnoremap', 'jb',
  --       \ ':call feedkeys("\<C-O>")<CR>', 'jump-back')
  --
  -- call dotvim#mapping#define_name('n', '+no')
  -- call dotvim#mapping#define_leader('nnoremap', 'nl',
  --       \ ':nohl<CR>:call multihighlight#nohighlight_all()<CR>',
  --       \ 'no-highlight')
  --
  -- call dotvim#mapping#define_name('h', '+highlight')
  -- call dotvim#mapping#define_leader('nnoremap', 'hn',
  --       \ ':call multihighlight#new_highlight("n")<CR>', 'new-highlight')
  -- call dotvim#mapping#define_leader('nnoremap', 'hj',
  --       \ ':call multihighlight#navigation(1)<CR>', 'next-match')
  -- call dotvim#mapping#define_leader('nnoremap', 'hk',
  --       \ ':call multihighlight#navigation(0)<CR>', 'next-match')
  --
  -- nnoremap <silent> * :call multihighlight#new_highlight('n')<CR>
  -- nnoremap <silent> n :call multihighlight#navigation(1)<CR>
  -- nnoremap <silent> N :call multihighlight#navigation(0)<CR>
  -- " nnoremap <silent> / :call dotvim#crate#dotvim#input_pattern()<CR>
  --
  -- call dotvim#mapping#define_leader('nnoremap', 'q', ':q<CR>', 'quit')
  -- call dotvim#mapping#define_leader('nnoremap', 'x', ':wq<CR>', 'save-and-quit')
  -- call dotvim#mapping#define_leader('nnoremap', 'Q', ':confirm qall<CR>', 'quit-all')
  --
  -- call dotvim#mapping#define_name('t', '+toggle')
  -- call dotvim#mapping#define_leader('nnoremap', 'tq',
  --       \ ':call dotvim#api#window#get().toggleQuickfix()<CR>',
  --       \ 'toggle-quickfix')
  --
  -- nnoremap <Plug>(window_w) <C-W>w
  -- nnoremap <Plug>(window_r) <C-W>r
  -- nnoremap <Plug>(window_d) <C-W>c
  -- nnoremap <Plug>(window_q) <C-W>q
  -- nnoremap <Plug>(window_j) <C-W>j
  -- nnoremap <Plug>(window_k) <C-W>k
  -- nnoremap <Plug>(window_h) <C-W>h
  -- nnoremap <Plug>(window_l) <C-W>l
  -- nnoremap <Plug>(window_H) <C-W>5<
  -- nnoremap <Plug>(window_L) <C-W>5>
  -- nnoremap <Plug>(window_J) :resize +5<CR>
  -- nnoremap <Plug>(window_K) :resize -5<CR>
  -- nnoremap <Plug>(window_b) <C-W>=
  -- nnoremap <Plug>(window_s1) <C-W>s
  -- nnoremap <Plug>(window_s2) <C-W>s
  -- nnoremap <Plug>(window_v1) <C-W>v
  -- nnoremap <Plug>(window_v2) <C-W>v
  -- nnoremap <Plug>(window_2) <C-W>v
  -- nnoremap <Plug>(window_x) <C-W>x
  -- nnoremap <Plug>(window_p) <C-W>p
  --
  -- call dotvim#mapping#define_name('w', '+window')
  -- call dotvim#mapping#define_leader('nnoremap', 'wv',
  --       \ ':call feedkeys("\<Plug>(window_v1)")<CR>', 'split-window-right')
  -- call dotvim#mapping#define_leader('nnoremap', 'w-',
  --       \ ':call feedkeys("\<Plug>(window_s1)")<CR>', 'split-window-below')
  -- call dotvim#mapping#define_leader('nnoremap', 'w=',
  --       \ ':call feedkeys("\<Plug>(window_b)")<CR>', 'balance-window')
  --
  -- call dotvim#mapping#define_leader('nnoremap', 'wr',
  --       \ ':call feedkeys("\<Plug>(window_r)")<CR>',
  --       \ 'rotate-windows-rightwards')
  -- call dotvim#mapping#define_leader('nnoremap', 'wx',
  --       \ ':call feedkeys("\<Plug>(window_x)")<CR>',
  --       \ 'exchange-window-with-next')
  -- call dotvim#mapping#define_leader('nnoremap', 'ww',
  --       \ ':call feedkeys("\<Plug>(window_w)")<CR>', 'move-to-next-window')
  -- call dotvim#mapping#define_leader('nnoremap', 'wp',
  --       \ ':call feedkeys("\<Plug>(window_p)")<CR>',
  --       \ 'move-to-previous-access-window')
  --
  -- call dotvim#mapping#define_leader('nnoremap', 'wh',
  --       \ ':call feedkeys("\<Plug>(window_h)")<CR>', 'move-window-left')
  -- call dotvim#mapping#define_leader('nnoremap', 'wj',
  --       \ ':call feedkeys("\<Plug>(window_j)")<CR>', 'move-window-down')
  -- call dotvim#mapping#define_leader('nnoremap', 'wk',
  --       \ ':call feedkeys("\<Plug>(window_k)")<CR>', 'move-window-up')
  -- call dotvim#mapping#define_leader('nnoremap', 'wl',
  --       \ ':call feedkeys("\<Plug>(window_l)")<CR>', 'move-window-right')
  --
  -- call dotvim#mapping#define_name('c', '+clipboard')
  -- " keybinding for global copy/paste
  -- vnoremap <silent>cc :'<,'>w! /tmp/vimtmp<CR>
  -- call dotvim#mapping#define_leader('nnoremap', 'cc',
  --       \ ":w! /tmp/vimtmp<CR>", 'global-copy-all')
  -- call dotvim#mapping#define_leader('nnoremap', 'cv',
  --       \ ":r! cat /tmp/vimtmp<CR>", 'global-paste')
  --
  -- nnoremap <silent><leader> :WhichKey '<Space>'<CR>
  --
  -- " inoremap jk <Esc>
  --
  -- " }}}
  --
  -- if has('nvim') && !exists('g:fvim_loaded')
  --   set wildoptions=pum
  -- endif
  --
  -- command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
  --
  -- " TODO(hawtian): add support clipboard here!
  -- let l:clipboard_program = get(s:vars, 'clipboard_program', '')
  -- if l:clipboard_program == 'lemonade'
  --   let l:lemonade_cmd = get(s:vars, 'lemonade_cmd', 'lemonade')
  --   let g:clipboard = {
  --         \   'name': 'remote-clipboard',
  --         \   'copy': {
  --         \     '+': l:lemonade_cmd . ' copy',
  --         \     '*': l:lemonade_cmd . ' copy',
  --         \   },
  --         \   'paste': {
  --         \     '+': l:lemonade_cmd . ' paste',
  --         \     '*': l:lemonade_cmd . ' paste',
  --         \   },
  --         \   'cache_enabled': 1,
  --         \ }
  -- endif
  --
  -- " vim which key {{{
  -- augroup WhichKeySettings
  --   au!
  --   au FileType which_key set noshowmode noruler
  --         \| au BufLeave <buffer> set laststatus=2 showmode ruler
  -- augroup END
  -- let g:which_key_centered = 0
  -- " }}}
  --
  -- " quickui {{{
  -- let g:quickui_border_style = 2
  -- " TODO(hawtian): fix color
  -- hi! QuickBG ctermfg=0 ctermbg=7 guifg=#EFEEEA guibg=#2F343F
  -- " hi! QuickKey term=bold ctermfg=9 gui=bold guifg=#FFCE5B
  -- " hi! QuickSel cterm=bold ctermfg=0 ctermbg=2 gui=bold guibg=#50c6d8 guifg=#A18BD3
  -- " hi! QuickOff ctermfg=59 guifg=#4C8273
  -- " hi! QuickHelp ctermfg=247 guifg=#959173
  -- " }}}


