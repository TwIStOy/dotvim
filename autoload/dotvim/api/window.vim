let s:self = {}
let s:autoclose_window_type = get(s:, 'autoclose_window_type', [])

function! dotvim#api#window#get() abort
  return deepcopy(s:self)
endfunction

function! s:self.addAutocloseType(tp) abort
  call add(s:autoclose_window_type, a:tp)
endfunction

function! s:self.findQuickfixWindow() abort
  for i in range(1, bufnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:self.toggleQuickfix() abort
  let has_quickfix = self.findQuickfixWindow()
  if has_quickfix
    cclose
  else
    copen
  endif
endfunction

function s:self.enableAutoclose() abort
  augroup AutoCloseGroup
    au!
    au BufEnter * call s:CheckLastWindow()
  augroup END
endfunction

function s:CheckLastWindow() abort
  let total = winnr('$')
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if index(s:autoclose_window_type, getbufvar(bnum, '&buftype')) != -1
      let total -= 1
      continue
    endif

    if index(s:autoclose_window_type, getbufvar(bnum, '&ft')) != -1
      let total -= 1
      continue
    endif
  endfor

  if total == 0
    quitall!
  endif
endfunction

