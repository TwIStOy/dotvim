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
  elseif l:theme ==# 'typewriter'
    call add(l:plugins, 'logico-dev/typewriter')
  elseif l:theme ==# 'two-firewatch'
    call add(l:plugins, 'rakr/vim-two-firewatch')
  elseif l:theme ==# 'github'
    call add(l:plugins, 'cormacrelf/vim-colors-github')
  elseif l:theme ==# 'spacegray'
    call add(l:plugins, 'ajh17/Spacegray.vim')
  elseif l:theme ==# 'sacredforest'
    call add(l:plugins, 'KKPMW/sacredforest-vim')
  elseif l:theme ==# 'onedark'
    call add(l:plugins, 'joshdick/onedark.vim')
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
  elseif l:theme ==# 'typewriter'
    colorscheme typewriter

    if exists('g:lightline')
      let g:lightline.colorscheme = 'typewriter_light'
    endif
  elseif l:theme ==# 'two-firewatch'
    colorscheme two-firewatch

    let g:two_firewatch_italics=1
    if exists('g:lightline')
      let g:lightline.colorscheme = 'twofirewatch'
    endif
  elseif l:theme ==# 'github'
    colorscheme github

    let g:github_colors_extra_functions = 1
    let g:github_colors_soft = 1

    if exists('g:lightline')
      let g:lightline.colorscheme = 'github'
    endif
  elseif l:theme ==# 'spacegray'
    colorscheme spacegray
  elseif l:theme ==# 'sacredforest'
    colorscheme sacredforest

    if exists('g:lightline')
      let g:lightline.colorscheme = 'sacredforest'
    endif
  elseif l:theme ==# 'onedark'
    colorscheme onedark

    let g:onedark_terminal_italics = 1

    if exists('g:lightline')
      let g:lightline.colorscheme = 'onedark'
    endif
  endif
endfunction

