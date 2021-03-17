let s:vars = get(s:, 'vars', {})

function! dotvim#crate#theme#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#theme#plugins() abort
  let l:theme = get(s:vars, 'theme', 'unknown')

  let l:theme_map = {
        \   'challenger-deep': {
        \     'repo': 'challenger-deep-theme/vim',
        \     'reg': {
        \       'name': 'challenger-deep',
        \       'normalized_name': 'challenger-deep'
        \     }
        \   },
        \   'onehalf': {
        \     'repo': 'sonph/onehalf',
        \     'reg': { 'rtp': 'vim' }
        \   },
        \   'tender': 'jacoborus/tender.vim',
        \   'gruvbox': 'morhetz/gruvbox',
        \   'typewriter': 'logico-dev/typewriter',
        \   'two-firewatch': 'rakr/vim-two-firewatch',
        \   'github': 'cormacrelf/vim-colors-github',
        \   'spacegray': 'ajh17/Spacegray.vim',
        \   'sacredforest': 'KKPMW/sacredforest-vim',
        \   'onedark': 'joshdick/onedark.vim',
        \   'vim-one': 'rakr/vim-one',
        \   'snow': 'nightsense/snow',
        \   'janah': 'mhinz/vim-janah',
        \   'moonfly': 'bluz71/vim-moonfly-colors',
        \   'night-owl': 'haishanh/night-owl.vim',
        \   'soft-era': 'soft-aesthetic/soft-era-vim',
        \   'cosmic_latte': 'nightsense/cosmic_latte',
        \   'edge': 'sainnhe/edge',
        \   'equinusocio_material': 'chuling/vim_equinusocio_material',
        \   'ayu': 'ayu-theme/ayu-vim',
        \   'candid': 'flrnd/candid.vim',
        \   'ci_dark': 'chuling/ci_dark',
        \   'nightfly': 'bluz71/vim-nightfly-guicolors'
        \ }

  let l:plugin = get(l:theme_map, l:theme, 'sainnhe/edge')
  let l:plugins = []
  if type(l:plugin) == v:t_dict
    call add(l:plugins, l:plugin['repo'])

    call dotvim#plugin#reg(l:plugin['repo'], l:plugin['reg'])
  else
    call add(l:plugins, l:plugin)
  endif

  return l:plugins
endfunction

function! dotvim#crate#theme#postConfig() abort
  let l:theme = get(s:vars, 'theme', 'unknown')

  let l:theme_map = {
        \   'challenger-deep': {
        \     'vim': 'challenger_deep',
        \     'lightline': 'challenger_deep'
        \   },
        \   'onehalf': {
        \     'vim': 'onehalfdark',
        \     'lightline': 'onehalfdark'
        \   },
        \   'tender': {
        \     'vim': 'tender',
        \     'lightline': 'tender'
        \   },
        \   'gruvbox': {
        \     'vim': 'gruvbox',
        \     'lightline': 'gruvbox'
        \   },
        \   'typewriter': {
        \     'vim': 'typewriter',
        \     'lightline': 'typewriter_light'
        \   },
        \   'two-firewatch': {
        \     'vim': 'two-firewatch',
        \     'lightline': 'twofirewatch',
        \     'settings': {
        \       'two_firewatch_italics': 1
        \     }
        \   },
        \   'github': {
        \     'vim': 'github',
        \     'lightline': 'github',
        \     'settings': {
        \       'github_colors_extra_functions': 1,
        \       'github_colors_soft': 1
        \     }
        \   },
        \   'spacegray': {
        \     'vim': 'spacegray',
        \   },
        \   'sacredforest': {
        \     'vim': 'sacredforest',
        \     'lightline': 'sacredforest'
        \   },
        \   'onedark': {
        \     'vim': 'onedark',
        \     'lightline': 'onedark',
        \     'settings': {
        \       'onedark_terminal_italics': 1
        \     }
        \   },
        \   'vim-one': {
        \     'vim': 'one',
        \     'settings': {
        \       'one_allow_italics': 1
        \     }
        \   },
        \   'snow': {
        \     'vim': 'snow',
        \     'func': 'theme_apply_snow'
        \   },
        \   'janah': {
        \     'vim': 'janah',
        \   },
        \   'moonfly': {
        \     'vim': 'moonfly',
        \     'lightline': 'moonfly',
        \     'settings': {
        \       'moonflyCursorLineNr': 0,
        \       'moonflyCursorColor': 1,
        \       'moonflyUnderlineMatchParen': 1
        \     }
        \   },
        \   'night-owl': {
        \     'vim': 'night-owl',
        \   },
        \   'soft-era': {
        \     'vim': 'soft-era',
        \   },
        \   'cosmic_latte': {
        \     'vim': 'cosmic_latte',
        \     'func': 'theme_apply_cosmic_latte'
        \   },
        \   'edge': {
        \     'vim': 'edge',
        \     'lightline': 'edge'
        \   },
        \   'equinusocio_material': {
        \     'vim': 'equinusocio_material',
        \     'lightline': 'equinusocio_material',
        \     'settings': {
        \       'equinusocio_material_vertsplit': 'visible',
        \       'equinusocio_material_style': 'default'
        \     }
        \   },
        \   'ayu': {
        \     'vim': 'ayu',
        \     'func': 'theme_apply_ayu'
        \   },
        \   'candid': {
        \     'vim': 'candid',
        \     'lightline': 'candid'
        \   },
        \   'ci_dark': {
        \     'vim': 'ci_dark',
        \     'lightline': 'ci_dark'
        \   },
        \   'nightfly': {
        \     'vim': 'nightfly',
        \     'func': 'theme_apply_nightfly'
        \   }
        \ }

  let l:theme_config = get(l:theme_map, l:theme, {
        \   'vim': 'edge',
        \   'lightline': 'edge'
        \ })

  set termguicolors

  if has_key(l:theme_config, 'settings')
    for l:name in keys(l:theme_config['settings'])
      let g:{l:name} = l:theme_config['settings'][l:name]
    endfor
  endif

  if has_key(l:theme_config, 'func')
    call s:{l:theme_config['func']}()
  else
    " exec 'set background=' . get(s:vars, 'background', 'dark')
    if has_key(l:theme_config, 'lightline')
      let g:lightline.colorscheme = l:theme_config['lightline']
    endif
  endif

  exec 'colorscheme ' . l:theme_config['vim']

  if !has('nvim')
    autocmd VimEnter * syntax on
  endif

  augroup ThemeTransparentBackground
    autocmd! VimEnter * call s:set_background_transparent()
  augroup END
endfunction

function! s:set_background_transparent()
  " make all background transparent
  " FIXME(hawtian): this seems not work
  if !exists('g:fvim_loaded') && !exists(':GonvimVersion')
    hi NonText ctermbg=NONE guibg=NONE
    hi Normal guibg=NONE ctermbg=NONE
  endif
endfunction

function! s:theme_apply_snow() abort
  exec 'set background=' . get(s:vars, 'background', 'dark')
  if exists('g:lightline')
    let g:lightline.colorscheme = 'snow_' . get(s:vars, 'background', 'dark')
  endif
endfunction

function! s:theme_apply_cosmic_latte() abort
  exec 'set background=' . get(s:vars, 'background', 'light')

  if exists('g:lightline')
    let g:lightline.colorscheme = 'cosmic_latte_' .
          \ get(s:vars, 'background', 'light')
  endif
endfunction

function! s:theme_apply_ayu() abort
  let g:ayucolor = get(s:vars, 'background', 'light')

  if exists('g:lightline')
    let g:lightline.colorscheme = 'ayu'
  endif
endfunction

function! s:theme_apply_nightfly() abort
  let g:nightflyCursorColor = 1
  let g:nightflyUnderlineMatchParen = 1
  let g:nightflyTransparent = 1

  if exists('g:lightline')
    let g:lightline.colorscheme = 'nightfly'
  endif
endfunction
