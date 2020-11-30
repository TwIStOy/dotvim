function! dotvim#mapping#register_buffer_event() abort
  augroup DotvimMappingBuffer
    autocmd FileType * call s:_buffer_autocmd()
  augroup END
endfunction

let s:filetype_mappings = get(s:, 'filetype_mappings', {})

function! dotvim#mapping#add_desc(ft, key, desc)
  let keys = split(a:key, '\zs')

  if !has_key(s:filetype_mappings, a:ft)
    let s:filetype_mappings[a:ft] = {}
  endif

  call s:_add_desc_internal(s:filetype_mappings[a:ft], keys, a:desc)
endfunction

function! s:_merge_desc(lhs, rhs)
  if a:lhs == 'which_key_ignore'
    return a:rhs
  endif

  return a:lhs . '/' . a:rhs
endfunction

function! s:_add_desc_internal(table, keys, desc)
  if has_key(a:table, a:keys[0])
    let old_value = a:table[a:keys[0]]

    if len(a:keys) == 1
      " last key,
      "   - if old_value is string, replace it to '{old_value}/{a:desc}'
      "   - if old_value is dict, replace old_value.name to '{old_value}/{a:desc}'
      if type(old_value) == v:t_string
        let a:table[a:keys[0]] = s:_merge_desc(old_value, a:desc)
      else
        let a:table[a:keys[0]].name = s:_merge_desc(old_value, a:desc)
      endif
    else
      " not last,
      "   - if old_value is string, replace to { 'name': old_value }
      "   - if old_value is dict, no action
      if type(old_value) == v:t_string
        let a:table[a:keys[0]] = {
              \   'name': old_value
              \ }
      endif
    endif
  else
    if len(a:keys) == 1
      " last key
      let a:table[a:keys[0]] = a:desc
    else
      let a:table[a:keys[0]] = {}
    endif
  endif

  if len(a:keys) > 1
    call s:_add_desc_internal(a:table[a:keys[0]], a:keys[1:], a:desc)
  endif
endfunction

function! s:_buffer_autocmd() abort
  if has_key(b:, 'which_key_map')
    return
  endif

  let b:which_key_map = get(s:filetype_mappings, '*', {})
  let l:ft = &filetype
  let l:ft_map = get(s:filetype_mappings, l:ft, {})

  call s:_merge_dict_recursive(b:which_key_map, l:ft_map)
endfunction

function! s:_merge_dict_recursive(expr1, expr2) abort
  if type(a:expr1) != v:t_dict || type(a:expr2) != v:t_dict
    return
  endif

  for key in keys(a:expr2)
    if !has_key(a:expr1, key)
      let a:expr1[key] = a:expr2[key]
      continue
    endif

    call s:_merge_dict_recursive(a:expr1[key], a:expr2[key])
  endfor
endfunction

function! s:_gen_dict(...) abort
  if a:0 == 1
    " final
    return a:1
  endif
  return { a:1: call('<SID>_gen_dict', a:000[1:]) }
endfunction

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

