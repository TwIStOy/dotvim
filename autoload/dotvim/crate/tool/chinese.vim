let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#chinese#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#chinese#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'rlue/vim-barbaric')

  return l:plugins
endfunction

