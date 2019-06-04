let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#lmake#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#lmake#plugins() abort
  augroup dotvimLmakeProejct
    autocmd FileType c,cpp call s:do_cpp()
  augroup END

  return ['TwIStOy/lmake.vim']
endfunction

function! s:do_cpp() abort
  if lmake#is_lmake_project()
    let &makeprg = "~/compile.py"
  endif
endfunction

