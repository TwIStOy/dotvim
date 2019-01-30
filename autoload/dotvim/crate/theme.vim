let s:vars = get(s:, 'vars', {})

function! dotvim#crate#theme#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#theme#plugins() abort
  let l:plugins = []

  if get(s:vars, 'theme', 'unknown') ==# 'challenger-deep'
    call dotvim#plugin#reg('challenger-deep-theme/vim', {
          \ 'name': 'challenger-deep',
          \ 'normalized_name': 'challenger-deep'
          \ })

    call add(l:plugins, 'challenger-deep-theme/vim')
  endif

  return l:plugins
endfunction

function! dotvim#crate#theme#postConfig() abort
  if get(s:vars, 'theme', 'unknown') ==# 'challenger-deep'
    colorscheme challenger_deep

    if exists('g:lightline')
      let g:lightline.colorscheme = 'challenger_deep'
    endif
  endif
endfunction

