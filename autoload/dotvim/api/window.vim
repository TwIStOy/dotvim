let s:self = {}

function! dotvim#api#window#get() abort
  return deepcopy(s:self)
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

