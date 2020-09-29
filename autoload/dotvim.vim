scriptencoding utf-8

let s:logger = dotvim#api#import('logging').getLogger('main')
let g:dotvim_root = $HOME . '/.dotvim'

function! dotvim#bootstrap() abort
  call s:read_custom_file()

  call dotvim#command#defineCommand()
  let g:_dotvim_minlvl = get(get(g:dotvimCustomSetting, 'global', {}),
        \ 'minloglvl', 0)

  " leader settings {{{
  let g:mapleader = "\<Space>"
  let g:maplocalleader = ','
  " }}}

  call dotvim#api#import('window').enableAutoclose()

  " install if dein is missing
  call dotvim#plugin#installMissingDein()

  " enable crates from config
  call s:enabled_crates_from_config()

  " crate bootstrap
  call dotvim#crate#bootstrap()

  " register all treesitter parsers
  " call dotvim#vim#treesitter#register_all()
endfunction

function! s:read_custom_file() abort
  let l:custom_file = $HOME . '/.dotvim.toml'
  if !filereadable(expand(l:custom_file))
    call s:logger.warn('No custom file at ' . l:custom_file)
    let g:dotvimCustomSetting = {}
    return
  endif

  if has('nvim')
    " if nvim use lua version
    call s:read_custom_file_lua(l:custom_file)
  else
    " if vim, use vimscript version
    let g:dotvimCustomSetting = dotvim#api#import('data#toml').parseFile(l:custom_file)
  endif
endfunction

function! s:read_custom_file_lua(filename) abort
lua << EOL
  f = io.open(vim.api.nvim_eval('a:filename'), "rb")
  content = f:read('*all')
  f:close()

  TOML = require('toml')
  settings = TOML.parse(content)

  vim.api.nvim_set_var('dotvimCustomSetting', settings)
EOL
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

