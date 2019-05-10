let s:custom_header = [
      \ ' [ dotvim, last updated: ' . dotvim#version#version() . ' ]'
      \ ]
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
