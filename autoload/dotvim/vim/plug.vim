" proxy functions

let s:logger = dotvim#api#import('logging').getLogger('vim::plug')

function! dotvim#vim#plug#begin(path) abort
  call dein#begin(a:path)
endfunction

function! dotvim#vim#plug#end() abort
  call dein#end()

  if dein#check_install()
    call dein#install()
  endif

  call dein#call_hook('source')
endfunction

let s:_dotvim_builtin_root = g:dotvim_root . '/builtin'

function! dotvim#vim#plug#tap(plug) abort
  return dein#tap(a:plug)
endfunction

function! dotvim#vim#plug#source(...) abort
  silent! call dein#source(a:000)
endfunction

function! dotvim#vim#plug#builtinConfgExists(plug) abort
endfunction

function! dotvim#vim#plug#defineHook() abort
  let l:path = s:_dotvim_builtin_root . '/plugins/'
  let l:path .= split(g:dein#name, '\.')[0] . '.vim'
  call dein#config(g:dein#name, {
        \ 'hook_source': "call dotvim#utils#source('". l:path ."')"
        \ })
endfunction

function! dotvim#vim#plug#configBefore(plug) abort
  let l:path = s:_dotvim_builtin_root . '/before/' . a:plug
  if !matchend(a:plug, '.vim')
    let l:path .= '.vim'
  endif

  call dotvim#utils#source(l:path)
endfunction

" let g:_dotvim_plugins = get(g:, '_dotvim_plugins', [])
let g:_dotvim_plugins = get(g:, '_dotvim_plugins', {})

function! dotvim#vim#plug#add(plug, ...) abort
  if has_key(g:_dotvim_plugins, a:plug)
    return
  endif

  if a:0 > 0
    call dein#add(a:plug, a:1)
  else
    call dein#add(a:plug)
  endif

  let g:_dotvim_plugins[a:plug] = 1
endfunction

let g:_dotvim_dein_root = get(g:, 'dotvim_dein_root', $HOME . '/.cache/dein')
function! dotvim#vim#plug#env()
  execute 'set runtimepath+=' . g:_dotvim_dein_root . '/repos/github.com/Shougo/dein.vim'
endfunction

