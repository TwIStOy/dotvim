let s:command_defined = 0

function! dotvim#command#defineCommand() abort
  if s:command_defined
    return
  endif
endfunction

