let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#git#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#git#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('tpope/vim-fugitive', { 'lazy': 1 })
  call add(l:plugins, 'tpope/vim-fugitive')

  call dotvim#plugin#reg('junegunn/gv.vim', {
        \ 'on_cmd': ['GV', 'GV!', 'GV?']
        \ })
  call add(l:plugins, 'junegunn/gv.vim')

  return l:plugins
endfunction

function! dotvim#crate#tool#git#postConfig() abort
  call timer_start(600, 'dotvim#crate#tool#git#_lazy_load')
endfunction

function! dotvim#crate#tool#git#_lazy_load(timer) abort
  call dotvim#vim#plug#source('vim-fugitive')
endfunction


