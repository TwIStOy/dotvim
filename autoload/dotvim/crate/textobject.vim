function! dotvim#crate#textobject#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'kana/vim-textobj-user')
  call add(l:plugins, 'kana/vim-textobj-indent')
  call add(l:plugins, 'kana/vim-textobj-line')
  call add(l:plugins, 'kana/vim-textobj-entire')

  return l:plugins
endfunction

