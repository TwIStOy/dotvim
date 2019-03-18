scriptencoding utf-8

let s:vars = get(s:, 'vars', {})

function! dotvim#crate#edit#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#edit#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('osyo-manga/vim-jplus', {
        \   'on_map' : '<Plug>(jplus'
        \ })
  call add(l:plugins, 'osyo-manga/vim-jplus')

  call add(l:plugins, 'tpope/vim-repeat')

  call add(l:plugins, 'ntpeters/vim-better-whitespace')

  return l:plugins
endfunction

function! dotvim#crate#edit#config() abort
  " osyo-manga/vim-jplus {{{
  nmap J <Plug>(jplus)
  vmap J <Plug>(jplus)
  " }}}

  " ntpeters/vim-better-whitespace {{{
  hi ExtraWhitespace guifg=#FF2626 gui=underline ctermfg=124 cterm=underline
  let g:better_whitespace_enabled=1
  let g:strip_whitespace_on_save=1
  " }}}
endfunction

