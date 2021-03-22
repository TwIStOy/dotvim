function! dotvim#crate#snippets#plugins() abort
  return ['TwIStOy/ultisnips']
endfunction

function! dotvim#crate#snippets#config() abort
  let g:UltiSnipsExpandTrigger="<c-e>"
  let g:UltiSnipsJumpForwardTrigger="<c-f>"
  let g:UltiSnipsJumpBackwardTrigger="<c-b>"

  py3 from snippet_tools.cpp import register_postfix_snippets
  py3 register_postfix_snippets()
endfunction

