let s:vars = get(s:, 'vars', {})

function! dotvim#crate#gui#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#gui#config() abort
  call timer_start(30, 'dotvim#crate#gui#_delay_loaded')
endfunction

function! dotvim#crate#gui#_delay_loaded(timer) abort
  if exists('g:fvim_loaded')
    " fvim gui

    let &guifont = get(s:vars, 'font', 'Iosevka SS06:h16')
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>


    FVimCursorSmoothMove v:false
    FVimCursorSmoothBlink v:true

    FVimUIPopupMenu v:false
    FVimFontAutoSnap v:true
  elseif exists('g:GuiLoaded')
    " nvim-qt gui

    let &guifont = get(s:vars, 'font', 'Iosevka SS06:h16')
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>

    GuiTabline 1
    GuiPopupmenu 0

    call GuiWindowMaximized(1)
  elseif exists('g:vv')
    " vv gui

    VVset fontfamily='Iosevka\ SS06'
    VVset fontsize=15
    VVset windowheight=100%
    VVset windowwidth=100%
    VVset windowleft=0
    VVset windowtop=0
  endif
endfunction

