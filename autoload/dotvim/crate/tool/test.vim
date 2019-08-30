let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#test#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#test#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'junegunn/vader.vim')

  return l:plugins
endfunction


