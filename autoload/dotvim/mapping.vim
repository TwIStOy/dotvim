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

let g:dotvim_mapping = get(g:, 'dotvim_mapping', {})

" example:
"   @type: xmap
"   @key: ta
"   @action: <Plug>(EasyAlign)
"   @a:1: desc
function! dotvim#mapping#define_leader(type, key, action, ...) abort
  let l:cmd = a:type . ' <silent><leader>' . a:key . ' ' .a:action
  execute l:cmd

  if a:0 > 0
    let l:keys = split(a:key, '\zs')
    let l:name_dict = call('dotvim#mapping#_gen_dict', keys + [a:1])
    call dotvim#mapping#_merge_dict(g:dotvim_mapping, l:name_dict)
  endif
endfunction

function! dotvim#mapping#define_name(key, name) abort
  let keys = split(a:key, '\zs')

  let name_dict = call('dotvim#mapping#_gen_dict', keys + ['name', a:name])
  call dotvim#mapping#_merge_dict(g:dotvim_mapping, name_dict)
endfunction

function! dotvim#mapping#_merge_dict(expr1, expr2) abort
  if type(a:expr1) != v:t_dict || type(a:expr2) != v:t_dict
    " throw 'Error'
    return
  endif

  for key in keys(a:expr2)
    if !has_key(a:expr1, key)
      let a:expr1[key] = a:expr2[key]
      continue
    endif

    call dotvim#mapping#_merge_dict(a:expr1[key], a:expr2[key])
    " let exp1 = a:expr1[key]
    " let exp2 = a:expr2[key]

    " if type(exp1) == type(exp2) && type(exp1) == type({})
    "   call dotvim#mapping#_merge_dict(exp1, exp2)
    " elseif type(exp1) == type(exp2) && type(exp1) == type([])
    "   call extend(exp1, exp2)
    "   continue
    " else
    "   " final override
    "   let a:expr1[key] = a:expr2[key]
    " endif
  endfor
endfunction

function! dotvim#mapping#_gen_dict(...) abort
  if a:0 == 1
    " final
    return a:1
  endif
  return { a:1: call('dotvim#mapping#_gen_dict', a:000[1:]) }
endfunction

