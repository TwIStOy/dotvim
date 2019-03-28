let s:logger = dotvim#api#import('logging').getLogger('utils')

function! dotvim#utils#source(file) abort
  if filereadable(expand(a:file))
    execute 'source ' . fnameescape(a:file)
  else
    call s:logger.warn('Try to source file ' . a:file . ', but failed.')
  endif
endfunction

function! dotvim#utils#globpath(path, expr) abort
	if has('patch-7.4.279')
		return globpath(a:path, a:expr, 1, 1)
	else
		return split(globpath(a:path, a:expr), '\n')
	endif
endfunction

function! dotvim#utils#repo_home() abort
  return trim(system('git rev-parse --show-toplevel'))
endfunction

