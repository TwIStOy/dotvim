function! dotvim#crate#textobject#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'kana/vim-textobj-user')
  call add(l:plugins, ['kana/vim-textobj-indent',          { 'lazy': 1 }])
  call add(l:plugins, ['kana/vim-textobj-line',            { 'lazy': 1 }])
  call add(l:plugins, ['kana/vim-textobj-entire',          { 'lazy': 1 }])
  call add(l:plugins, ['lucapette/vim-textobj-underscore', { 'lazy': 1 }])
  call add(l:plugins, ['sgur/vim-textobj-parameter',       { 'lazy': 1 }])

  return l:plugins
endfunction

function! dotvim#crate#textobject#config() abort
  call timer_start(500, 'dotvim#crate#textobject#_lazy_load')
endfunction

function! dotvim#crate#textobject#_lazy_load(timer) abort
  call dotvim#vim#plug#source(
        \ 'vim-textobj-indent',
        \ 'vim-textobj-line',
        \ 'vim-textobj-entire',
        \ 'vim-textobj-underscore',
        \ 'vim-textobj-parameter'
        \ )
endfunction


