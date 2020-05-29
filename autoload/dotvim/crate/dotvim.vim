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

  if !dotvim#crate#hasLoaded('theme')
    call add(l:plugins, 'tpope/vim-vividchalk')
  endif

  call dotvim#plugin#reg('liuchengxu/vim-which-key', {
        \ 'on_cmd': ['WhichKey', 'WhichKey!'],
        \ 'builtin_conf': 1
        \ })
  call add(l:plugins, 'liuchengxu/vim-which-key')

  call add(l:plugins, 'TwIStOy/multihighlight.nvim')

  call add(l:plugins, 'skywind3000/vim-quickui')

  call dotvim#plugin#reg('dstein64/vim-startuptime', {
        \ 'on_cmd': ['StartupTime']
        \ })
  call add(l:plugins, 'dstein64/vim-startuptime')

  return l:plugins
endfunction

function! dotvim#crate#dotvim#config() abort
  if !has('nvim')
    set term=xterm
  endif

  " startify {{{
  augroup dotvimStartify
    autocmd!
    autocmd VimEnter *
          \  if !argc()
          \|   call dein#source('vim-startify')
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

  set nolazyredraw
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
  let g:rust_recommended_style = 0

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
  call dotvim#api#import('window').add_uncountable_type('defx')
  call dotvim#api#import('window').add_uncountable_type('quickfix')

  nnoremap <silent><F3> :call <SID>fast_forward_to_defx()<CR>
  nnoremap <silent><F4> :call quickui#tools#list_buffer('e')<CR>
  nnoremap <silent>;; :call dotvim#quickui#open_context(&ft)<CR>

  " default keybindings {{{
  for l:i in range(1, 9)
    call dotvim#mapping#define_leader('nnoremap',
          \ string(l:i),
          \ ':call dotvim#api#window#get().move_to(' .  l:i. ')<CR>',
          \ 'Window ' . l:i)
  endfor

  call dotvim#mapping#define_name('f', '+file')
  call dotvim#mapping#define_leader('nnoremap', 'fs',
        \ ':update<CR>', 'save')

  let g:dotvim_defx_parameters = [
        \ '-split=vertical',
        \ '-winwidth=' . get(s:vars, 'defx_width', 35),
        \ '-ignored-files=*.d',
        \ '-toggle',
        \ ]
  nnoremap <silent><Plug>(toggle_defx) :call dotvim#crate#dotvim#_call_defx()<CR>

  call dotvim#mapping#define_leader('nnoremap', 'ft',
        \ ':call feedkeys("\<Plug>(toggle_defx)")<CR>',
        \ 'toggle-file-explorer')

  call dotvim#mapping#define_name('j', '+jump')
  call dotvim#mapping#define_leader('nnoremap', 'jb',
        \ ':call feedkeys("\<C-O>")<CR>', 'jump-back')

  call dotvim#mapping#define_name('n', '+no')
  call dotvim#mapping#define_leader('nnoremap', 'nl',
        \ ':nohl<CR>:call multihighlight#nohighlight_all()<CR>',
        \ 'no-highlight')

  call dotvim#mapping#define_name('h', '+highlight')
  call dotvim#mapping#define_leader('nnoremap', 'hn',
        \ ':call multihighlight#new_highlight("n")<CR>', 'new-highlight')
  call dotvim#mapping#define_leader('nnoremap', 'hj',
        \ ':call multihighlight#navigation(1)<CR>', 'next-match')
  call dotvim#mapping#define_leader('nnoremap', 'hk',
        \ ':call multihighlight#navigation(0)<CR>', 'next-match')

  nnoremap <silent> * :call multihighlight#new_highlight('n')<CR>
  nnoremap <silent> n :call multihighlight#navigation(1)<CR>
  nnoremap <silent> N :call multihighlight#navigation(0)<CR>
  " nnoremap <silent> / :call dotvim#crate#dotvim#input_pattern()<CR>

  call dotvim#mapping#define_leader('nnoremap', 'q', ':q<CR>', 'quit')
  call dotvim#mapping#define_leader('nnoremap', 'x', ':wq<CR>', 'save-and-quit')
  call dotvim#mapping#define_leader('nnoremap', 'Q', ':confirm qall<CR>', 'quit-all')

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

  inoremap jk <Esc>

  " }}}

  if has('nvim') && !exists('g:fvim_loaded')
    set wildoptions=pum
  endif

  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

  " TODO(hawtian): add support clipboard here!
  let l:clipboard_program = get(s:vars, 'clipboard_program', '')
  if l:clipboard_program == 'lemonade'
    let l:lemonade_cmd = get(s:vars, 'lemonade_cmd', 'lemonade')
    let g:clipboard = {
          \   'name': 'remote-clipboard',
          \   'copy': {
          \     '+': l:lemonade_cmd . ' copy',
          \     '*': l:lemonade_cmd . ' copy',
          \   },
          \   'paste': {
          \     '+': l:lemonade_cmd . ' paste',
          \     '*': l:lemonade_cmd . ' paste',
          \   },
          \   'cache_enabled': 1,
          \ }
  endif

  " quickui {{{
  let g:quickui_border_style = 2
  " TODO(hawtian): fix color
  hi! QuickBG ctermfg=0 ctermbg=7 guifg=#EFEEEA guibg=#2F343F
  " hi! QuickKey term=bold ctermfg=9 gui=bold guifg=#FFCE5B
  " hi! QuickSel cterm=bold ctermfg=0 ctermbg=2 gui=bold guibg=#50c6d8 guifg=#A18BD3
  " hi! QuickOff ctermfg=59 guifg=#4C8273
  " hi! QuickHelp ctermfg=247 guifg=#959173
  " }}}
endfunction

function! dotvim#crate#dotvim#postConfig() abort
  if !dotvim#crate#hasLoaded('theme')
    colorscheme vividchalk
  endif

  call defx#custom#option('_', {
        \ 'ignored_files': '*.d',
        \ })
endfunction

function! dotvim#crate#dotvim#no_highlight() abort
  execute 'nohlsearch'
  call multihighlight#nohighlight_all()
endfunction

function! dotvim#crate#dotvim#_call_defx() abort
  let l:cmd = join(g:dotvim_defx_parameters, ' ')
  execute 'Defx ' . l:cmd
endfunction

function! dotvim#crate#dotvim#input_pattern() abort " {{{
  let l:pattern = input("Search and Highlight Pattern: ")

  call multihighlight#highlight_word(l:pattern, 'n')
endfunction " }}}

function! dotvim#crate#dotvim#print(error, response) abort
  if empty(a:error)
    " Refer to coc.nvim 79cb11e
    " No document symbol provider exists when response is null.
    if a:response isnot v:null
      echo a:response
    endif
  endif
endfunction

function! s:fast_forward_to_defx() abort
  for l:i in range(1, winnr('$'))
    let l:tp = getbufvar(winbufnr(l:i), '&ft')

    if l:tp == 'defx'
      execute ':' . l:i . 'wincmd w'
      return
    endif
  endfor

  call dotvim#crate#dotvim#_call_defx()
endfunction

" vim: fdm=marker
