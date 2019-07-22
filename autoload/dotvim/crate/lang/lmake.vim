let s:vars = get(s:, 'vars', {})
let s:setted = get(s:, 'setted', 0)

if get(s:, 'sourced', 0)
  finish
endif

let s:sourced = 1

function! dotvim#crate#lang#lmake#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#lmake#plugins() abort
  augroup dotvimLmakeProejct
    autocmd FileType cpp call s:do_cpp()
  augroup END

  return ['TwIStOy/lmake.vim']
endfunction

function! s:do_cpp() abort
  if lmake#is_lmake_project() && !s:setted
    let &makeprg = "~/compile.py"

    exec 'cd ' . lmake#get_build_root()

    exec 'CocStart'
  endif
endfunction

