let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#doc#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#doc#plugins() abort
  call dotvim#plugin#reg('TwIStOy/vim-doge', {
        \ 'on_cmd': ['DogeGenerate', 'DogeCreateDocStandard']
        \ })
  return ['TwIStOy/vim-doge']
endfunction

function! dotvim#crate#tool#doc#config() abort
  let g:doge_enable_mappings = 0

  if has_key(s:vars, 'libclang_path')
    let g:doge_libclang_path = s:vars['libclang_path']
  endif
endfunction

