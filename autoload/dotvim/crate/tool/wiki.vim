function! dotvim#crate#tool#wiki#plugins() abort
  return [ 'vimwiki/vimwiki' ]
endfunction

function! dotvim#crate#tool#wiki#config() abort
  let g:vimwiki_map_prefix = '<Leader>k'
  call dotvim#mapping#define_name('k', 'wiki')

  augroup ToolWikiGroup
    au!
    autocmd BufNewFile,BufRead *.wiki set filetype=viwiki
  augroup END
endfunction

