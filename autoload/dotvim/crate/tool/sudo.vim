let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#sudo#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#sudo#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'lambdalisue/suda.vim')

  return l:plugins
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

