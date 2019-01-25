let s:plugins = []
let s:plug_options = {}

let s:logger = dotvim#api#import('logging').getLogger('plugin')

let s:dein_root = get(g:, 'dotvim_dein_root', $HOME . '/.cache/dein')

function! dotvim#plugin#reg(plug, ...) abort
  if index(s:plugins, a:plug) < 0
    call s:logger.info('Add plug: ' . a:plug . ', with settings: ' . string(a:000))
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

function! dotvim#plugin#doInstall() abort
  execute 'set runtimepath+=' . s:dein_root . '/repos/github.com/Shougo/dein.vim'

  if dein#load_state(s:dein_root)
    call dein#begin(s:dein_root)

    " let dein manage dein
    call dein#add(s:dein_root . '/repos/github.com/Shougo/dein.vim')
    call dein#add('wsdjeg/dein-ui.vim')

    for l:plug in s:plugins
      call dein#add(l:plug, get(s:plug_options, l:plug, {}))
    endfor

    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    call dein#install()
  endif
endfunction

