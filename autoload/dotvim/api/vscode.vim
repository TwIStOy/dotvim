let s:vscode = {}

function s:vscode.goToDefinition() abort
  if exists('b:vscode_controlled') && b:vscode_controlled
    exe "normal! m'"
    call VSCodeNotify("editor.action.revealDefinition")
  endif
endfunction

function! s:vscode.format(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.formatSelection", line1, line2, 0)
endfunction

function! s:vscode.commentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

function! s:vscode.hover()
  normal! gv
  call VSCodeNotify('editor.action.showHover')
endfunction

function! s:vscode.openCommandsInVisualMode() abort
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

function! dotvim#api#vscode#get() abort
  return deepcopy(s:vscode)
endfunction
