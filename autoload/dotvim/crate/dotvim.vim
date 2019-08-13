let s:logger = dotvim#api#import('logging').getLogger('crate::dotvim')

function! dotvim#crate#dotvim#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#dotvim#plugins() abort
  let l:plugins = []

  if !has('nvim')
    call add(l:plugins, 'roxma/nvim-yarp')
    call add(l:plugins, 'roxma/vim-hug-neovim-rpc')
  endif

  call dotvim#plugin#reg('skywind3000/asyncrun.vim', {
        \ 'on_cmd': ['AsyncRun', 'AsyncStop']
        \ })
  call add(l:plugins, 'skywind3000/asyncrun.vim')

  call dotvim#plugin#reg('mhinz/vim-startify', {
        \ 'on_cmd': ['Startify'],
        \ 'builtin_conf': 1
        \ })
  call add(l:plugins, 'mhinz/vim-startify')

  call dotvim#plugin#reg('Shougo/defx.nvim', {
        \ 'on_cmd': ['Defx'],
        \ 'builtin_conf': 1
        \ })
  call add(l:plugins, 'Shougo/defx.nvim')

  call dotvim#plugin#reg('Shougo/denite.nvim', {
        \ 'on_cmd': ['Denite', 'DeniteBufferDir',
        \            'DeniteCursorWord', 'DeniteProjectDir']
        \ })
  call add(l:plugins, 'Shougo/denite.nvim')

  call add(l:plugins, 'tpope/vim-vividchalk')

  call dotvim#plugin#reg('liuchengxu/vim-which-key', {
        \ 'on_cmd': ['WhichKey', 'WhichKey!'],
        \ 'builtin_conf': 1
        \ })
  call add(l:plugins, 'liuchengxu/vim-which-key')

  call dotvim#plugin#reg('wsdjeg/vim-todo', {
        \ 'on_cmd': ['OpenTodo']
        \ })
  call add(l:plugins, 'wsdjeg/vim-todo')

  return l:plugins
endfunction

function! dotvim#crate#dotvim#config() abort
  " startify {{{
  augroup dotvimStartify
    autocmd!
    autocmd VimEnter *
          \  if !argc()
          \|   call dein#source('mhinz/vim-startify')
          \|   silent! Startify
          \| endif
  augroup END
  " }}}

  if !has('nvim')
    set nocompatible
    set backspace=2
  endif

  " disable arrows {{{
  map <Left>  <Nop>
  map <Right> <Nop>
  map <Up>    <Nop>
  map <Down>  <Nop>
  " }}}

  set title
  set ttyfast

  set lazyredraw
  set termguicolors
  if has('nvim') && exists('&pumblend')
    " make popupmenu semi-transparency
    set pumblend=20
  endif

  " no bells {{{
  set noerrorbells
  set novisualbell
  set t_vb=
  " }}}

  if get(s:vars, 'use_relativenumber', 1)
    set number relativenumber

    if get(s:vars, 'enable_relativenumber_toggle', 0)
      augroup RelativeNumberToggle
        autocmd!
        autocmd WinEnter,FocusGained,InsertLeave * set relativenumber
        autocmd WinLeave,FocusLost,InsertEnter * set norelativenumber
      augroup END
    endif
  else
    set nu
  endif

  if get(s:vars, 'use_cursorline', 1)
    augroup CursorLineToggle
      autocmd!
      autocmd InsertLeave,WinEnter * set cursorline
      autocmd InsertEnter,WinLeave * set nocursorline
    augroup END
  endif

  " rainbow settings {{{
  let g:rainbow_active = 1
  " }}}

  set tabstop=2
  set shiftwidth=2
  set expandtab
  set smartindent
  set autoindent

  set exrc

  " auto-move quickfix to botright
  autocmd FileType qf wincmd J

  execute 'set colorcolumn=' . string(get(s:vars, 'use_colorcolumn', 80))

  if has('nvim')
    set inccommand=split
  endif

  set scrolloff=5

  set timeoutlen=500

  call dotvim#api#import('window').addAutocloseType('quickfix')
  call dotvim#api#import('window').addAutocloseType('defx')

  " default keybindings {{{
  for l:i in range(1, 9)
    call dotvim#mapping#define_leader('nnoremap',
          \ string(l:i), ':' . l:i .  'wincmd w<CR>', 'Window ' . l:i)
  endfor

  call dotvim#mapping#define_name('f', '+file')
  call dotvim#mapping#define_leader('nnoremap', 'fs',
        \ ':update<CR>', 'save')
  call dotvim#mapping#define_leader('nnoremap', 'ft',
        \ ':Defx -split=vertical -winwidth=30 -ignored-files=*.d -toggle<CR>',
        \ 'toggle-file-explorer')

  call dotvim#mapping#define_name('j', '+jump')
  call dotvim#mapping#define_leader('nnoremap', 'jb',
        \ ':call feedkeys("\<C-O>")<CR>', 'jump-back')

  call dotvim#mapping#define_name('n', '+no')
  call dotvim#mapping#define_leader('nnoremap', 'nl', ':nohl<CR>', 'no-highlight')

  call dotvim#mapping#define_leader('nnoremap', 'q', ':q<CR>', 'quit')
  call dotvim#mapping#define_leader('nnoremap', 'x', ':wq<CR>', 'save-and-quit')
  call dotvim#mapping#define_leader('nnoremap', 'Q', ':qa!<CR>', 'force-quit')

  call dotvim#mapping#define_name('t', '+toggle')
  call dotvim#mapping#define_leader('nnoremap', 'tq',
        \ ':call dotvim#api#window#get().toggleQuickfix()<CR>',
        \ 'toggle-quickfix')

  nnoremap <Plug>(window_w) <C-W>w
  nnoremap <Plug>(window_r) <C-W>r
  nnoremap <Plug>(window_d) <C-W>c
  nnoremap <Plug>(window_q) <C-W>q
  nnoremap <Plug>(window_j) <C-W>j
  nnoremap <Plug>(window_k) <C-W>k
  nnoremap <Plug>(window_h) <C-W>h
  nnoremap <Plug>(window_l) <C-W>l
  nnoremap <Plug>(window_H) <C-W>5<
  nnoremap <Plug>(window_L) <C-W>5>
  nnoremap <Plug>(window_J) :resize +5<CR>
  nnoremap <Plug>(window_K) :resize -5<CR>
  nnoremap <Plug>(window_b) <C-W>=
  nnoremap <Plug>(window_s1) <C-W>s
  nnoremap <Plug>(window_s2) <C-W>s
  nnoremap <Plug>(window_v1) <C-W>v
  nnoremap <Plug>(window_v2) <C-W>v
  nnoremap <Plug>(window_2) <C-W>v
  nnoremap <Plug>(window_x) <C-W>x
  nnoremap <Plug>(window_p) <C-W>p

  if has('nvim')
    set wildoptions=pum
  endif

  call dotvim#mapping#define_name('w', '+window')
  call dotvim#mapping#define_leader('nnoremap', 'wv',
        \ ':call feedkeys("\<Plug>(window_v1)")<CR>', 'split-window-right')
  call dotvim#mapping#define_leader('nnoremap', 'w-',
        \ ':call feedkeys("\<Plug>(window_s1)")<CR>', 'split-window-below')
  call dotvim#mapping#define_leader('nnoremap', 'w=',
        \ ':call feedkeys("\<Plug>(window_b)")<CR>', 'balance-window')

  call dotvim#mapping#define_leader('nnoremap', 'wr',
        \ ':call feedkeys("\<Plug>(window_r)")<CR>',
        \ 'rotate-windows-rightwards')
  call dotvim#mapping#define_leader('nnoremap', 'wx',
        \ ':call feedkeys("\<Plug>(window_x)")<CR>',
        \ 'exchange-window-with-next')
  call dotvim#mapping#define_leader('nnoremap', 'ww',
        \ ':call feedkeys("\<Plug>(window_w)")<CR>', 'move-to-next-window')
  call dotvim#mapping#define_leader('nnoremap', 'wp',
        \ ':call feedkeys("\<Plug>(window_p)")<CR>',
        \ 'move-to-previous-access-window')

  call dotvim#mapping#define_leader('nnoremap', 'wh',
        \ ':call feedkeys("\<Plug>(window_h)")<CR>', 'move-window-left')
  call dotvim#mapping#define_leader('nnoremap', 'wj',
        \ ':call feedkeys("\<Plug>(window_j)")<CR>', 'move-window-down')
  call dotvim#mapping#define_leader('nnoremap', 'wk',
        \ ':call feedkeys("\<Plug>(window_k)")<CR>', 'move-window-up')
  call dotvim#mapping#define_leader('nnoremap', 'wl',
        \ ':call feedkeys("\<Plug>(window_l)")<CR>', 'move-window-right')

  call dotvim#mapping#define_name('c', '+clipboard')
  " keybinding for global copy/paste
  vnoremap <silent>cc :'<,'>w! /tmp/vimtmp<CR>
  call dotvim#mapping#define_leader('nnoremap', 'cc',
        \ ":w! /tmp/vimtmp<CR>", 'global-copy-all')
  call dotvim#mapping#define_leader('nnoremap', 'cv',
        \ ":r! cat /tmp/vimtmp<CR>", 'global-paste')

  nnoremap <silent><leader> :WhichKey '<Space>'<CR>

  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

  inoremap jk <Esc>

  " }}}
endfunction

function! dotvim#crate#dotvim#postConfig() abort
  colorscheme vividchalk

  call defx#custom#option('_', {
        \ 'ignored_files': '*.d',
        \ })
endfunction

