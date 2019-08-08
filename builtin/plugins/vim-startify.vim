let s:loaded = get(s:, 'loaded', 0)

if s:loaded
  finish
endif

let s:loaded = 1

let s:left_indent = '   '
function! s:read_title_file() abort
  let l:title_file = g:dotvim_root . '/builtin/plugins/title.txt'
  let l:title_buffer = readfile(l:title_file)
  let l:max_length = 0
  for l:line in l:title_buffer
    call add(s:custom_header, s:left_indent . l:line)
    let l:max_length = max([l:max_length, len(l:line)])
  endfor
  return l:max_length
endfunction

let s:custom_header = []

function! s:build_header() abort
  let l:version_header = '[ dotvim, last updated: ' . dotvim#version#version() . ' ]'
  let l:title_length = s:read_title_file()

  call add(s:custom_header, '')
  call add(s:custom_header, s:left_indent .
        \ repeat(' ', l:title_length - len(l:version_header)) .
        \ l:version_header)
  let l:maintainer_header = '< MAINTAINER: Hawtian Wang(twistoy.wang@gmail.com) >'
  call add(s:custom_header, s:left_indent .
        \ repeat(' ', l:title_length - len(l:maintainer_header)) .
        \ l:maintainer_header)
endfunction

call s:build_header()

let s:list_order = [
      \ [' Recent Files:'],
      \ 'files',
      \ [' Project Files:'],
      \ 'dir',
      \ [' Sessions:'],
      \ 'sessions',
      \ [' Bookmarks:'],
      \ 'bookmarks',
      \ [' Commands:'],
      \ 'commands',
      \ ]

let g:startify_custom_header = s:custom_header
let g:startify_list_order = s:list_order

