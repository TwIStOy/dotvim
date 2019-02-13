let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#lmake#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#lmake#plugins() abort
  call dotvim#plugin#reg('TwIStOy/lmake.vim', {
        \ 'on_ft': ['bzl']
        \ })
  
  return ['TwIStOy/lmake.vim']
endfunction

