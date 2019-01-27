let s:plugins = []
let s:plug_options = {}

let s:logger = dotvim#api#import('logging').getLogger('plugin')

let s:dein_root = get(g:, 'dotvim_dein_root', $HOME . '/.cache/dein')

function! dotvim#plugin#reg(plug, ...) abort
  if index(s:plugins, a:plug) < 0
    call add(s:plugins, a:plug)
  endif

  if a:0 == 1
    " save configuration
    let s:plug_options[a:plug] = a:1
  endif
endfunction

function! dotvim#plugin#getOptions(plug) abort
  return get(s:plug_options, a:plug, {})
endfunction

function! dotvim#plugin#hasOptions(plug) abort
  return has_key(s:plug_options, a:plug)
endfunction

function! dotvim#plugin#installMissingDein() abort
  if !isdirectory(s:dein_root . '/repos/github.com/Shougo/dein.vim')
    echo "Installing dein..."
    execute '!curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh'
    execute '!sh /tmp/installer.sh ' . s:dein_root
  endif
endfunction

