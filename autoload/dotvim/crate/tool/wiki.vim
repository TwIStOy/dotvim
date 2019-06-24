let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#wiki#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#wiki#plugins() abort
  let l:plugins = []

  " call dotvim#plug#reg('vimwiki/vimwiki', {
  "       \ 'on_ft': ['vimwiki']
  "       \ })
  call add(l:plugins, 'vimwiki/vimwiki')

  return l:plugins
endfunction

function! dotvim#crate#tool#wiki#config() abort
  let g:vimwiki_map_prefix = '<Leader>k'
  call dotvim#mapping#define_name('k', 'wiki')

  augroup ToolWikiGroup
    au!
    autocmd BufNewFile,BufRead *.wiki set filetype=viwiki
endfunction

