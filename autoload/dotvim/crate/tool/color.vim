let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#color#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#color#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'lifepillar/vim-colortemplate')
  call add(l:plugins, 'RRethy/vim-hexokinase')

  return l:plugins
endfunction

function! dotvim#crate#tool#color#config() abort
endfunction

