function! dotvim#crate#dotvim#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#dotvim#plugins() abort
  let l:plugins = []

  if !has('nvim')
    call add(l:plugins, 'roxma/nvim-yarp')
    call add(l:plugins, 'roxma/vim-hug-neovim-rpc')
  endif

  call add(l:plugins, 'skywind3000/asyncrun.vim')
  call add(l:plugins, 'mhinz/vim-startify')

  call dotvim#plugin#reg('Shougo/defx.nvim', {
        \ 'on_cmd': ['Defx']
        \ })
  call add(l:plugins, 'Shougo/defx.nvim')

  call add(l:plugins, 'Shougo/denite.nvim')

  call add(l:plugins, 'tpope/vim-vividchalk')

  call add(l:plugins, 'luochen1990/rainbow')

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
  endif

  " rainbow settings {{{
  let g:rainbow_active = 1
  " }}}

  set tabstop=2 shiftwidth=2 autoindent expandtab

  " auto-move quickfix to botright
  autocmd FileType qf wincmd J

  " startify settings {{{
  let g:startify_custom_header = [ ' [ dotvim, last updated: 2018.1.26 ]' ]
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
endfunction

function! dotvim#crate#dotvim#postConfig() abort
  colorscheme vividchalk
endfunction

