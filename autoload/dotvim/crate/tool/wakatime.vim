let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#wakatime#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#wakatime#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('wakatime/vim-wakatime', {
        \   'lazy' : 1
        \ })
  call add(l:plugins, 'wakatime/vim-wakatime')

  return l:plugins
endfunction

function! dotvim#crate#tool#wakatime#config() abort
endfunction

function! dotvim#crate#tool#wakatime#postConfig() abort
  call timer_start(600, 'dotvim#crate#tool#wakatime#_lazy_start')
endfunction

function! dotvim#crate#tool#wakatime#_lazy_start(timer) abort
  call dotvim#vim#plug#source('vim-wakatime')
endfunction

