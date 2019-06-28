let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#calendar#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#calendar#plugins() abort
  let l:plugins = []

  " call dotvim#plug#reg('itchyny/calendar.vim', {
  "       \ 'on_cmd': ['Calendar']
  "       \ })
  call add(l:plugins, 'itchyny/calendar.vim')

  return l:plugins
endfunction

function! dotvim#crate#tool#calendar#config() abort
  let g:calendar_google_calendar = 0
  let g:calendar_google_task = 0
endfunction

