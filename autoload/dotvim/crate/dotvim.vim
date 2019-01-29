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
  call add(l:plugins, 'mhinz/vim-startify')

  call dotvim#plugin#reg('Shougo/defx.nvim', {
        \ 'on_cmd': ['Defx'],
        \ 'builtin_conf': 1
        \ })
  call add(l:plugins, 'Shougo/defx.nvim')

  call add(l:plugins, 'Shougo/denite.nvim')

  call add(l:plugins, 'tpope/vim-vividchalk')

  call dotvim#plugin#reg('liuchengxu/vim-which-key', {
        \ 'lazy': 0,
        \ })
  call add(l:plugins, 'liuchengxu/vim-which-key')

  return l:plugins
endfunction

function! dotvim#crate#dotvim#config() abort
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

  " no bells {{{
  set noerrorbells
  set novisualbell
  set t_vb=
  " }}}

  " show trailing white-space {{{
  hi ExtraWhitespace guifg=#FF2626 gui=underline ctermfg=124 cterm=underline
  match ExtraWhitespace /\s\+%/
  " }}}

  if get(s:vars, 'use_relativenumber', 1)
    set number relativenumber
    augroup RelativeNumberToggle
      autocmd!
      autocmd BufEnter, FocusGained, InsertLeave * set relativenumber
      autocmd BufLeave, FocusLost,   InsertEnter * set norelativenumber
    augroup END
  else
    set nu
  endif

  " rainbow settings {{{
  let g:rainbow_active = 1
  " }}}

  set tabstop=2
  set shiftwidth=2
  set expandtab
  set smartindent
  set autoindent

  " auto-move quickfix to botright
  autocmd FileType qf wincmd J

  " startify settings {{{
  let g:startify_custom_header = [ ' [ dotvim, last updated: 2018.1.28 ]' ]
  let g:startify_list_order = [
        \ [' Recent Files:'],
        \ 'files',
        \ [' Project:'],
        \ 'dir',
        \ [' Sessions:'],
        \ 'sessions',
        \ [' Bookmarks:'],
        \ 'bookmarks',
        \ [' Commands:'],
        \ 'commands',
        \ ]
  " }}}

  execute 'set colorcolumn=' . string(get(s:vars, 'use_colorcolumn', 80))

  if has('nvim')
    set inccommand=split
  endif

  set scrolloff=5

  set timeoutlen=500

  " default keybindings {{{
  for l:i in range(1, 9)
    call dotvim#mapping#define_leader('nnoremap',
          \ string(l:i), ':' . l:i .  'wincmd w<CR>', 'Window ' . l:i)
  endfor

  call dotvim#mapping#define_name('f', '+file')
  call dotvim#mapping#define_leader('nnoremap', 'fs',
        \ ':update<CR>', 'save')
  call dotvim#mapping#define_leader('nnoremap', 'ft',
        \ ':Defx -split=vertical -winwidth=30 -toggle<CR>', 'toggle-file-explorer')

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
  
  call dotvim#mapping#define_name('w', '+window')
  call dotvim#mapping#define_leader('nnoremap', 'wv',
        \ ':call feedkeys("\<Plug>(window_v1)")<CR>', 'split-window-below')
  call dotvim#mapping#define_leader('nnoremap', 'w-',
        \ ':call feedkeys("\<Plug>(window_s1)")<CR>', 'split-window-below')
  call dotvim#mapping#define_leader('nnoremap', 'w=',
        \ ':call feedkeys("\<Plug>(window_b)")<CR>', 'balance-window')

  nnoremap <silent><leader> :WhichKey '<Space>'<CR>

  inoremap jk <Esc>
  " }}}
endfunction

function! dotvim#crate#dotvim#postConfig() abort
  colorscheme vividchalk

  call which_key#register('<Space>', 'g:dotvim_mapping')
endfunction

