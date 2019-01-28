function! dotvim#crate#better#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'tpope/vim-surround')

  call dotvim#plugin#reg('Yggdroot/LeaderF', {
        \ 'build': './install.sh'
        \ })
  call add(l:plugins, 'Yggdroot/LeaderF')

  call add(l:plugins, 'andymass/vim-matchup')
  call add(l:plugins, 'tenfyzhong/axring.vim')
  call add(l:plugins, 'bogado/file-line')

  call add(l:plugins, 'tpope/vim-speeddating')
  call add(l:plugins, 'tpope/vim-repeat')
  call add(l:plugins, 'Yggdroot/indentLine')

  call dotvim#plugin#reg('godlygeek/tabular', {
        \ 'on_cmd': 'Tabularize'
        \ })
  call add(l:plugins, 'godlygeek/tabular')

  call dotvim#plugin#reg('junegunn/vim-easy-align', {
        \ 'on_cmd': ['<Plug>(EasyAlign)', 'EsayAlign']
        \ })
  call add(l:plugins, 'junegunn/vim-easy-align')

  call add(l:plugins, 'luochen1990/rainbow')

  return l:plugins
endfunction

function! dotvim#crate#better#config() abort
  " enable vim-surround default keybindings {{{
  let g:surround_no_mappings = 0
  let g:surround_no_insert_mappings = 1
  " }}}

  " key mappings
endfunction

function! dotvim#crate#better#postConfig() abort

endfunction

" vim:set ft=vim sw=2 sts=2 et:
