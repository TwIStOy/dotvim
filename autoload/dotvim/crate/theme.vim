let s:vars = get(s:, 'vars', {})

function! dotvim#crate#theme#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#theme#plugins() abort
  let l:plugins = []

  let l:theme = get(s:vars, 'theme', 'unknown')
  if l:theme ==# 'challenger-deep'
    call dotvim#plugin#reg('challenger-deep-theme/vim', {
          \ 'name': 'challenger-deep',
          \ 'normalized_name': 'challenger-deep'
          \ })

    call add(l:plugins, 'challenger-deep-theme/vim')
  elseif l:theme ==# 'onehalf'
    call dotvim#plugin#reg('sonph/onehalf', {
          \ 'rtp': 'vim',
          \ })

    call add(l:plugins, 'sonph/onehalf')
  elseif l:theme ==# 'tender'
    call add(l:plugins, 'jacoborus/tender.vim')
  elseif l:theme ==# 'gruvbox'
    call add(l:plugins, 'morhetz/gruvbox')
  endif

  return l:plugins
endfunction

function! dotvim#crate#theme#postConfig() abort
  let l:theme = get(s:vars, 'theme', 'unknown')

  if l:theme ==# 'challenger-deep'
    colorscheme challenger_deep

    if exists('g:lightline')
      let g:lightline.colorscheme = 'challenger_deep'
    endif
  elseif l:theme ==# 'onehalf'
    colorscheme onehalfdark

    if exists('g:lightline')
      let g:lightline.colorscheme = 'onehalfdark'
    endif
  elseif l:theme ==# 'tender'
    colorscheme tender

    if exists('g:lightline')
      let g:lightline.colorscheme = 'tender'
    endif
  elseif l:theme ==# 'gruvbox'
    colorscheme gruvbox

    hi Normal guibg=NONE ctermbg=NONE
    if exists('g:lightline')
      let g:lightline.colorscheme = 'gruvbox'
    endif
  endif
endfunction

