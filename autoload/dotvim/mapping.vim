function! dotvim#mapping#define(type, key, value, ...) abort
  let feedkeys_mode = 'm'
  let map = split(a:type)[0]
  if map =~# 'nore'
    let feedkeys_mode = 'n'
  endif

  let gexe = a:value
  if a:value =~? '^<plug>'
    let gexe = '\' . a:value
  elseif a:value =~? ':.\+<cr>$'
    let gexe = substitute(gexe, '<cr>', '\<cr>', 'g')
    let gexe = substitute(gexe, '<CR>', '\<CR>', 'g')
    let gexe = substitute(gexe, '<Esc>', '\<Esc>', 'g')
  endif

  exec a:type . ' ' . a:key . ' ' . a:value

  " TODO(hawtian): impl
endfunction
