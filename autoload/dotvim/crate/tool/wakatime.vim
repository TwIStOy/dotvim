let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#wakatime#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#wakatime#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'wakatime/vim-wakatime')

  return l:plugins
endfunction

function! dotvim#crate#tool#wakatime#config() abort
endfunction

