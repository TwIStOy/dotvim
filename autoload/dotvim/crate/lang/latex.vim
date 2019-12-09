let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#latex#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#latex#plugins() abort
  let l:plugins = []

  return l:plugins
endfunction

