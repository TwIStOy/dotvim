function! dotvim#crate#lsp#plugins() abort
  call dotvim#plugin#reg('neoclide/coc.nvim', {
        \ 'build': 'yarn install'
        \ })

  return ['neoclide/coc.nvim']
endfunction

function! dotvim#crate#lsp#config() abort
endfunction
