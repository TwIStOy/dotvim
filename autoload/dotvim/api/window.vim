let s:self = {}
let s:autoclose_window_type = get(s:, 'autoclose_window_type', [])
let s:uncountable_type = get(s:, 'uncountable_type', {})

function! dotvim#api#window#get() abort
  return deepcopy(s:self)
endfunction

function! s:self.addAutocloseType(tp) abort
  call add(s:autoclose_window_type, a:tp)
endfunction

function! s:self.add_uncountable_type(tp) abort
  let s:uncountable_type[a:tp] = 1
endfunction

function! s:self.move_to(id) abort
  let new_id = s:skip_uncountable_window(a:id)
  if new_id
    execute ':' . new_id . 'wincmd w'
  endif
endfunction

function! s:is_uncountable(id) abort
  let tp = getbufvar(winbufnr(a:id), '&buftype')
  if has_key(s:uncountable_type, tp)
    return 1
  endif

  let tp = getbufvar(winbufnr(a:id), '&ft')
  if has_key(s:uncountable_type, tp)
    return 1
  endif

  return 0
endfunction

function! s:skip_uncountable_window(id) abort
  let rest = a:id
  for i in range(1, winnr('$'))
    if s:is_uncountable(i)
      continue
    endif

    let rest -= 1
    if rest == 0
      return i
    endif
  endfor
  return 0
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
    if tabpagenr('$') == 1
      quitall!
    else
      tabclose
    endif
  endif
endfunction

