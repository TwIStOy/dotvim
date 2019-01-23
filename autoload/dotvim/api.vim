let s:apis = {}

function! dotvim#api#import(name) abort
  if has_key(s:apis, a:name)
    return deepcopy(s:apis[a:name])
  endif

  let p = {}
  try
    let p = dotvim#api#{a:name}#get()
    let s:apis[a:name] = deepcopy(p)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  return p
endfunction

function! dotvim#api#register(name, api) abort
  if !empty(dotvim#api#import(a:name))
    echoerr '[Api]: ' . a:name . ' already existed!'
  else
    let s:apis[a:name] = deepcopy(a:api)
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
