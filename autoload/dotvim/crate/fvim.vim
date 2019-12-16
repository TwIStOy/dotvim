let s:vars = get(s:, 'vars', {})

function! dotvim#crate#fvim#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#fvim#config() abort
  call timer_start(500, 'dotvim#crate#fvim#_delayed_load')
endfunction

function! dotvim#crate#fvim#_delayed_load(timer)
  if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    let &guifont = get(s:vars, 'font', 'Iosevka SS06:h14')
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>

    FVimCursorSmoothMove v:false
    FVimCursorSmoothBlink v:true

    FVimUIPopupMenu v:false
    FVimFontAutoSnap v:true
  endif
endfunction

