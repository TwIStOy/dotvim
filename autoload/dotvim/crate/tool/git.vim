let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#git#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#git#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'tpope/vim-fugitive')

  call dotvim#plugin#reg('junegunn/gv.vim', {
        \ 'on_cmd': ['GV', 'GV!', 'GV?']
        \ })
  call add(l:plugins, 'junegunn/gv.vim')

  return l:plugins
endfunction



