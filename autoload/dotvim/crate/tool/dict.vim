let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#dict#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#dict#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'voldikss/vim-translate-me')

  return l:plugins
endfunction

function! dotvim#crate#tool#dict#config() abort
  let g:vtm_popup_window = 'floating'

  if has_key(s:vars, 'app_key')
    let g:vtm_youdao_app_key = s:vars['app_key']
  endif

  if has_key(s:vars, 'app_secret')
    let g:vtm_youdao_app_secret = s:vars['app_secret']
  endif

  call dotvim#mapping#define_name('d', '+dict')
  call dotvim#mapping#define_leader('nnoremap', 'dv',
        \ ':call vtm#Translate(expand("<cword>"), "complex")<CR>',
        \ 'translate-cursor')
endfunction

