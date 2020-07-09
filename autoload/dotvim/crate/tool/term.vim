function! dotvim#crate#tool#term#plugins() abort
  return ['chengzeyi/multiterm.vim']
endfunction

function! dotvim#crate#tool#term#config() abort
  nmap <F12> <Plug>(Multiterm)
  " In terminal mode `count` is impossible to press, but you can still use <F12>
  " to close the current floating terminal window without specifying its tag
  tmap <F12> <Plug>(Multiterm)
  " If you want to toggle in insert mode and visual mode
  imap <F12> <Plug>(Multiterm)
  xmap <F12> <Plug>(Multiterm)

  tnoremap <Esc> <C-\><C-N>
endfunction


