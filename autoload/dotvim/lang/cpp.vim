let s:logger = dotvim#api#import('logging').getLogger('lang#cpp')

function! dotvim#lang#cpp#foldExpr(lnum) abort " {{{
  let b:fold_type = get(b:, 'fold_type', {})

  let b:fold_type[a:lnum] = s:impl(a:lnum)

  return b:fold_type[a:lnum]
endfunction " }}}

function! s:impl(lnum)
  let line = getline(a:lnum)

  call s:logger.info('fold expr at line: ' . a:lnum)
  if s:is_include_line(a:lnum)
    return s:include_fold(a:lnum)
  elseif s:is_namespace_start_line(a:lnum)
    return ">1"
  elseif s:is_namespace_end_line(a:lnum)
    return "<1"
  endif

  return -1
endfunction

function! s:is_include_line(lnum)
  let line = getline(a:lnum)

  if line =~ '\v^\s*#include\s*'
    return 1
  endif

  return 0
endfunction

function! s:is_namespace_start_line(lnum) abort
  let line = getline(a:lnum)

  " example: namespace abc {
  if line =~ '\m^\s*namespace\s*.\{-}{'
    return 1
  endif

  return 0
endfunction

function! s:is_namespace_end_line(lnum) abort
  let line = getline(a:lnum)

  " example: }  // namespace abc
  if line =~ '\m^\s*}\s*\/\/\s*namespace\s*.*'
    return 1
  endif

  return 0
endfunction

function! s:include_fold(lnum) " {{{
  let i = 1
  let is_first_include = 1
  while i < a:lnum
    if s:is_include_line(i)
      let is_first_include = 0
      break
    endif
    let i += 1
  endwhile

  if is_first_include
    return ">1"
  endif

  let i = a:lnum + 1
  let is_last_include = 1
  while i <= line('$')
    if s:is_include_line(i)
      let is_last_include = 0
      break
    endif
    let i += 1
  endwhile

  if is_last_include
    return "<1"
  endif

  return '='
endfunction " }}}

" vim: foldmethod=marker
