function! dotvim#mapping#register_buffer_event() abort
  augroup DotvimMappingBuffer
    autocmd FileType * call s:_buffer_autocmd()
  augroup END
endfunction

let s:filetype_mappings = get(s:, 'filetype_mappings', {})

function! dotvim#mapping#add_desc(ft, key, desc)
  let keys = split(a:key, '\zs')

  if type(a:ft) == v:t_string
    let l:fts = [a:ft]
  else
    let l:fts = a:ft
  endif

  for l:ftype in l:fts
    if !has_key(s:filetype_mappings, l:ftype)
      let s:filetype_mappings[l:ftype] = {}
    endif

    call s:_add_desc_internal(s:filetype_mappings[l:ftype], keys, a:desc)
  endfor
endfunction

function! dotvim#mapping#dbg()
  return s:filetype_mappings
endfunction

function! dotvim#mapping#ft_mappings(ft)
  let l:res = deepcopy(get(s:filetype_mappings, '*', {}))
  let l:ft_map = get(s:filetype_mappings, a:ft, {})
  call s:_merge_dict_recursive(l:res, l:ft_map)
  return l:res
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

  let b:which_key_map = deepcopy(get(s:filetype_mappings, '*', {}))
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

" example:
"   @type: xmap
"   @key: ta
"   @action: <Plug>(EasyAlign)
"   @a:1: desc
function! dotvim#mapping#define_leader(type, key, action, ...) abort
  let l:cmd = a:type . ' <silent><leader>' . a:key . ' ' .a:action
  execute l:cmd

  if a:0 > 0
    call dotvim#mapping#add_desc('*', a:key, a:1)
  else
    call dotvim#mapping#add_desc('*', a:key, 'which_key_ignore')
  endif
endfunction

function! dotvim#mapping#define_name(key, name) abort
  call dotvim#mapping#add_desc('*', a:key, a:name)
endfunction

