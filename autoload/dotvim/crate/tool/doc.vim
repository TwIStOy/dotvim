function! dotvim#crate#tool#doc#plugins() abort
  call dotvim#plugin#reg('TwIStOy/vim-doge', {
        \ 'on_cmd': ['DogeGenerate', 'DogeCreateDocStandard']
        \ })
  return ['TwIStOy/vim-doge']
endfunction

function! dotvim#crate#tool#doc#config() abort
  let g:doge_enable_mappings = 0
endfunction

