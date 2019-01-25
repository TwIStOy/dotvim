let s:enabled_crates = []
let s:crate_vars = {}

let s:logger = dotvim#api#import('logging').getLogger('crate')

function! dotvim#crate#load(crate, ...) abort
  if index(s:enabled_crates, a:crate) != -1
    return
  endif

  call add(s:enabled_crates, a:crate)

  if a:0 == 1 && type(a:1) == v:t_dict
    try
      call dotvim#crate#{a:crate}#setVariables(a:1)
      let s:crate_vars[a:crate] = a:1
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry
  endif
endfunction

function! dotvim#crate#get() abort
  return s:enabled_crates
endfunction

function! dotvim#crate#hasLoaded(crate) abort
  return index(s:enabled_crates, a:crate) != -1
endfunction

function! dotvim#crate#bootstrap() abort
  call dotvim#vim#plug#env()

  call dotvim#vim#plug#begin(g:_dotvim_dein_root)

  " let dein manage dein itself
  call dein#add(g:_dotvim_dein_root . '/repos/github.com/Shougo/dein.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  for l:crate in dotvim#crate#get()
    " set global variables for current crate
    let g:dotvim#crate#name = l:crate
    call s:logger.info('Bootstrap crate: ' . l:crate)

    for l:plug in dotvim#crate#plugins(l:crate)
      call s:logger.info('Try to add plugin: ' . l:plug)
      let l:plug_last = split(l:plug, '/')[-1]

      if dotvim#plugin#hasOptions(l:plug)
        let l:plug_opt = dotvim#plugin#getOptions(l:plug)

        " add plug into dein
        call s:logger.info('Add plug ' . l:plug . ' with opt: ' . string(l:plug_opt))
        call dotvim#vim#plug#add(l:plug, l:plug_opt)

        if dotvim#vim#plug#tap(l:plug_last)
          if get(l:plug_opt, 'builtin_conf', 0)
            call dotvim#vim#plug#defineHook()
          endif
          if get(l:plug_opt, 'builtin_conf_before', 0)
            call dotvim#vim#plug#configBefore(l:plug_last)
          endif
        endif
      else
        call dotvim#vim#plug#add(l:plug)
      endif
    endfor

    call dotvim#crate#config(l:crate)

    unlet g:dotvim#crate#name
    call s:logger.info('Bootstrap crate: ' . l:crate . ' done.')
  endfor

  " add custom plugins from config files
  for l:plug in get(g:dotvimCustomSetting, 'extra_plugins', [])
    if type(l:plug) == v:t_dict
      if has_key(l:plug, 'name')
        if has_key(l:plug, 'opt') && type(l:plug.opt) == v:t_dict
          call dotvim#vim#plug#add(l:plug.name, l:plug.opt)
        endif
      endif
    elseif type(l:plug) == v:t_string
      call dotvim#vim#plug#add(l:plug)
    endif
  endfor

  call dotvim#vim#plug#end()
endfunction

function! dotvim#crate#plugins(crate) abort
  let p = []
  try
    let p = dotvim#crate#{a:crate}#plugins()
  catch /^Vim\%((\a\+)\)\=:E117/
    call s:logger.warn('No plugins function in crate: ' . a:crate)
  endtry
  return p
endfunction

function! dotvim#crate#config(crate) abort
  try
    call dotvim#crate#{a:crate}#config()
  catch /^Vim\%((\a\+)\)\=:E117/
    call s:logger.warn('No config function in crate: ' . a:crate)
  endtry
endfunction

