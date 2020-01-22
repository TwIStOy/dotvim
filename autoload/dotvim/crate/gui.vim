let s:vars = get(s:, 'vars', {})

function! dotvim#crate#gui#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#gui#config() abort
  call timer_start(200, 'dotvim#crate#gui#_delay_loaded')
endfunction

function! dotvim#crate#gui#_delay_loaded(timer) abort
  " good old 'set guifont' compatibility
  let &guifont = get(s:vars, 'font', 'Iosevka SS06:h16')

  " Ctrl-ScrollWheel for zooming in/out
  nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
  nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>

  if exists('g:fvim_loaded')
    " fvim gui

    FVimCursorSmoothMove v:false
    FVimCursorSmoothBlink v:true

    FVimUIPopupMenu v:false
    FVimFontAutoSnap v:true
  else
    " nvim-qt gui

    GuiTabline 1
    GuiPopupmenu 0
  endif
endfunction

