scriptencoding utf-8

let s:logger = dotvim#api#import('logging').getLogger('main')
let s:dotvim_root = $HOME . '/.dotvim'

function! dotvim#bootstrap() abort
  " TODO(hawtian): impl
  call s:read_custom_file()

  " leader settings {{{
  let g:mapleader = '\<Space>'
  let g:maplocalleader = ','
  " }}}

  " install if dein is missing
  call dotvim#plugin#installMissingDein()

  call dotvim#crate#initialize(s:dotvim_root . '/crates')

  " enable crates from config
  call s:enabled_crates_from_config()
endfunction

function! s:read_custom_file() abort
  let l:custom_file = $HOME . '/.dotvim.toml'
  if !filereadable(expand(l:custom_file))
    s:logger.warn('No custom file at ' . l:custom_file)
    let g:dotvimCustomSetting = {}
    return
  endif

  let g:dotvimCustomSetting = dotvim#api#import('data#toml').parseFile(l:custom_file)
endfunction

function! s:enabled_crates_from_config() abort
  let l:crates = get(g:dotvimCustomSetting, 'crates', {})
  for l:crate in l:crates
    if has_key(l:crate, 'name') && get(l:crate, 'enable', 1)
      call dotvim#crate#add(l:crate.name)
      for l:key in keys(l:crate)
        if l:key != 'name' && l:key != 'enable'
          call dotvim#crate#setVars(l:crate.name, l:key, l:crate[l:key])
        endif
      endfor
    endif
  endfor
endfunction

