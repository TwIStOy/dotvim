function! dotvim#crate#tool#sudo#plugins() abort
  return ['lambdalisue/suda.vim']
endfunction

function! dotvim#crate#tool#sudo#config() abort
  let g:suda#prefix = ['suda://', 'sudo://', '_://']
endfunction

function! s:sudo_write_current_file() abort
  let l:lhs = expand('%')

  try
    let l:echo_message = suda#write(l:lhs)
    redraw | echo l:echo_message
  finally
    doautocmd BufWritePost l:lhs
    checktime
  endtry
endfunction

