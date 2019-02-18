scriptencoding utf-8

let s:logger = dotvim#api#import('logging').getLogger('main')
let g:dotvim_root = $HOME . '/.dotvim'
let g:dotvim_last_updated_time = '2018.2.14'

function! dotvim#bootstrap() abort
  " TODO(hawtian): impl
  call s:read_custom_file()

  call dotvim#command#defineCommand()
  let g:_dotvim_minlvl = get(get(g:dotvimCustomSetting, 'global', {}),
        \ 'minloglvl', 0)

  " leader settings {{{
  let g:mapleader = "\<Space>"
  let g:maplocalleader = ','
  " }}}

  " install if dein is missing
  call dotvim#plugin#installMissingDein()

  " enable crates from config
  call s:enabled_crates_from_config()

  " crate bootstrap
  call dotvim#crate#bootstrap()
endfunction

function! s:load_crates() abort
  for l:crate in dotvim#crate#get()
  endfor
endfunction

function! s:read_custom_file() abort
  let l:custom_file = $HOME . '/.dotvim.toml'
  if !filereadable(expand(l:custom_file))
    call s:logger.warn('No custom file at ' . l:custom_file)
    let g:dotvimCustomSetting = {}
    return
  endif

  let g:dotvimCustomSetting = dotvim#api#import('data#toml').parseFile(l:custom_file)
endfunction

function! s:enabled_crates_from_config() abort
  let l:crates = get(g:dotvimCustomSetting, 'crates', [])
  let l:simple_enable = get(g:dotvimCustomSetting, 'enabled_crates', [])

  call dotvim#crate#load('dotvim', get(g:dotvimCustomSetting, 'global', {}))

  for l:crate in l:simple_enable
    call dotvim#crate#load(l:crate, {})
  endfor

  for l:crate in l:crates
    if has_key(l:crate, 'name') && get(l:crate, 'enable', 1)
      let l:crate_dict = deepcopy(l:crate)
      unlet l:crate_dict.name
      if has_key(l:crate, 'enable')
        unlet l:crate_dict.enable
      endif

      call dotvim#crate#load(l:crate.name, l:crate_dict)
    endif
  endfor
endfunction

