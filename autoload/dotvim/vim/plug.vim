" proxy functions

let s:logger = dotvim#api#import('logging').getLogger('vim::plug')

function! dotvim#vim#plug#begin(path) abort
  call dein#begin(a:path)
endfunction

function! dotvim#vim#plug#end() abort
  call dein#end()

  if dein#check_install()
    augroup DotvimAutoInstallMissing
      au!
      au VimEnter * call dein#install()
    augroup END
  endif

  call dein#call_hook('source')
endfunction

let s:_dotvim_builtin_root = g:dotvim_root . '/builtin'

function! dotvim#vim#plug#tap(plug) abort
  return dein#tap(a:plug)
endfunction

function! dotvim#vim#plug#builtinConfgExists(plug) abort
endfunction

function! dotvim#vim#plug#defineHook(plug) abort
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

let g:_dotvim_plugins = get(g:, '_dotvim_plugins', [])

function! dotvim#vim#plug#add(plug, ...) abort
  if index(g:_dotvim_plugins, a:plug) != -1
    return
  endif

  if a:0 > 0
    call dein#add(a:plug, a:1)
  else
    call dein#add(a:plug)
  endif

  call add(g:_dotvim_plugins, a:plug)
endfunction

let g:_dotvim_dein_root = get(g:, 'dotvim_dein_root', $HOME . '/.cache/dein')
function! dotvim#vim#plug#env()
  execute 'set runtimepath+=' . g:_dotvim_dein_root . '/repos/github.com/Shougo/dein.vim'
endfunction

