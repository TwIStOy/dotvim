function! dotvim#crate#snippets#plugins() abort
  return ['SirVer/ultisnips']
endfunction

function! dotvim#crate#snippets#config() abort
  let g:UltiSnipsExpandTrigger="<c-f>"
  let g:UltiSnipsJumpForwardTrigger="<c-f>"
  let g:UltiSnipsJumpBackwardTrigger="<c-b>"
endfunction

