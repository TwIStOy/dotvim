function! neoformat#formatters#cpp#myclangformat() abort
    return {
            \ 'exe': g:_dotvim_clang_format_exe,
            \ 'args': ['-assume-filename=' . expand('%:p'), '-style=file'],
            \ 'stdin': 1
            \ }
endfunction

