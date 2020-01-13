function! dotvim#crate#tool#doc#plugins() abort
  call dotvim#plugin#reg('kkoomen/vim-doge', {
        \ 'on_cmd': ['DogeGenerate', 'DogeCreateDocStandard']
        \ })
  return ['kkoomen/vim-doge']
endfunction

function! dotvim#crate#tool#doc#config() abort
  let g:doge_enable_mappings = 0
endfunction

