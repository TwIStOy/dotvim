function! dotvim#crate#tool#nuake#plugins() abort
  call dotvim#plugin#reg('Lenovsky/nuake', {
        \ 'on_cmd': ['Nuake']
        \ })
  return ['Lenovsky/nuake']
endfunction

function! dotvim#crate#tool#nuake#config() abort
  nnoremap <silent> <F4> :Nuake<CR>
  inoremap <silent> <F4> <C-\><C-n>:Nuake<CR>
  tnoremap <F4> <C-\><C-n>:Nuake<CR>
endfunction


