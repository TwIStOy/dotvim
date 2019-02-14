let s:command_defined = 0

function! dotvim#command#defineCommand() abort
  if s:command_defined
    return
  endif

  let s:command_defined = 1
  command! DotvimStatus call dotvim#crate#showCrates()
endfunction

