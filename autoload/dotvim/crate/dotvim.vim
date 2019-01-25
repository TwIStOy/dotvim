function! dotvim#crate#dotvim#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'skywind3000/asyncrun.vim')
  call add(l:plugins, 'mhinz/vim-startify')

  call dotvim#plugin#reg('scrooloose/nerdtree', {
        \ 'on_cmd': ['NERDTreeToggle', 'NERDTreeFind']
        \ })
  call add(l:plugins, 'scrooloose/nerdtree')

  call add(l:plugins, 'Shougo/denite.nvim')

  " call dotvim#plugin#reg('tpope/vim-vividchalk', {
        " \ })
  call add(l:plugins, 'tpope/vim-vividchalk')

  return l:plugins
endfunction

function! dotvim#crate#dotvim#postConfig() abort
  colorscheme vividchalk
endfunction

