function! dotvim#crate#better#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'tpope/vim-surround')

  call dotvim#plugin#reg('Yggdroot/LeaderF', {
        \ 'build': './install.sh'
        \ })
  call add(l:plugins, 'Yggdroot/LeaderF')

  return l:plugins
endfunction

function! dotvim#crate#better#config() abort
  " enable vim-surround default keybindings {{{
  let g:surround_no_mappings = 0
  let g:surround_no_insert_mappings = 1
  " }}}
endfunction

function! dotvim#crate#better#postConfig() abort

endfunction

" vim:set ft=vim sw=2 sts=2 et:
