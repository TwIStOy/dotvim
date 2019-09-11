function! dotvim#crate#tool#wakatime#plugins() abort
  call dotvim#plugin#reg('wakatime/vim-wakatime', {
        \   'lazy' : 1
        \ })
  return [ 'wakatime/vim-wakatime' ]
endfunction

function! dotvim#crate#tool#wakatime#postConfig() abort
  call timer_start(600, 'dotvim#crate#tool#wakatime#_lazy_start')
endfunction

function! dotvim#crate#tool#wakatime#_lazy_start(timer) abort
  call dotvim#vim#plug#source('vim-wakatime')
endfunction

