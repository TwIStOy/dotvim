let s:logger = dotvim#api#import('logging').getLogger('utils')

function! dotvim#utils#source(file) abort
  if filereadable(expand(a:file))
    execute 'source ' . fnameescape(a:file)
  else
    call s:logger.warn('Try to source file ' . a:file . ', but failed.')
  endif
endfunction


