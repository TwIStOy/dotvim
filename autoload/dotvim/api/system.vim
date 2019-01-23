let s:system = {}

let s:system.isWindows = has('win16') || has('win32') || has('win64')

let s:system.isLinux = has('unix') && !has('macunix') && !has('win32unix')

let s:system.isMac = has('macunix')

function s:system.name() abort
  if s:system.isLinux
    return 'linux'
  elseif s:system.isWindows
    if has('win32unix')
      return 'cygwin'
    else
      return 'windows'
    endif
  else
    return 'mac'
  endif
endfunction

function! dotvim#api#system#get() abort
  return deepcopy(s:system)
endfunction

