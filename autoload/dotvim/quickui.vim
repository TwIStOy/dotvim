let s:context_menu = get(s:, 'context_menu', {})

function! dotvim#quickui#append_context_menu(content, ftype) abort
  if has_key(s:context_menu, a:ftype)
    call extend(s:context_menu[a:ftype], ['-'] + a:content)
    return
  endif

  call extend(s:context_menu, { a:ftype: a:content, }, 'force')
endfunction

function! dotvim#quickui#open_context(ftype) abort
  let content = []
  call extend(content, get(s:context_menu, '*', []))
  call add(content, ['-'])
  call extend(content, get(s:context_menu, a:ftype, []))

  let opts = {'index':g:quickui#context#cursor}
  if len(content) == 0
    echo "No Context Menu Item!"
  else
    call quickui#context#open(content, opts)
  end
endfunction


