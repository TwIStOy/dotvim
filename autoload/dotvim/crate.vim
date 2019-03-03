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
        call s:logger.info('Add plug ' . l:plug . ' without opt')
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

  for l:crate in dotvim#crate#get()
    call dotvim#crate#postConfig(l:crate)
  endfor
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

function! dotvim#crate#postConfig(crate) abort
  try
    call dotvim#crate#{a:crate}#postConfig()
  catch /^Vim\%((\a\+)\)\=:E117/
    call s:logger.warn('No postConfig function in crate: ' . a:crate)
  endtry
endfunction

function! dotvim#crate#showCrates() abort
  let l:content = [
        \ 'Dotvim Crates:',
        \ ]
  let l:content = l:content + s:list_all_available_crates()
  let l:wincol = len(l:content[-1])

  let l:opt = {
        \ 'relative': 'editor',
        \ 'row': (winheight(0) - 20) / 2,
        \ 'col': (winwidth(0) - l:wincol) / 2,
        \ }

  let l:nr = bufnr('%')
  let l:buffer_id = nvim_create_buf(v:false, v:false)
  let l:winid = nvim_open_win(l:buffer_id, v:true,
        \ len(l:content), 20, l:opt)
  call nvim_buf_set_lines(l:buffer_id, 0, -1, v:true, l:content)

  nnoremap <buffer> q :q<cr>

  setlocal buftype=nofile bufhidden=wipe
  setlocal nobuflisted nolist noswapfile nowrap cursorline nospell
  setlocal norelativenumber nonumber

  setf DotvimCrateLister
  nnoremap <silent> <buffer> q :q<CR>
  map <buffer> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
        \ . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  set nomodifiable
endfunction

function! s:dein_use_repo_name() abort
  let l:plugins = dein#get()
  let rst = {}

  for name in keys(l:plugins)
    let rst[l:plugins[name].repo] = deepcopy(l:plugins[name])
  endfor

  return rst
endfunction

function! s:list_all_available_crates() abort
  let crates = dotvim#utils#globpath(&rtp, 'autoload/dotvim/crate/**/*.vim')
  let pattern = '/autoload/dotvim/crate/'

  let l:plugins_dict = s:dein_use_repo_name()
  let rst = []
  for crate in crates
    if crate =~# pattern
      let name = crate[matchend(crate, pattern):-5]
      let name = substitute(name, '/', '#', 'g')

      let status = index(s:enabled_crates, name) != -1 ? 'loaded' : 'not loaded'

      call add(rst, '')
      if status ==# 'loaded'
        call add(rst, '+ ' . name . ':' . repeat(' ', 45 - len(name)) . status)
        for plugin in dotvim#crate#plugins(name)
          let plug_status = get(l:plugins_dict, plugin,
                \ {'sourced': 0}).sourced ? 'sourced' : 'not sourced'
          call add(rst, '  * ' . plugin
                \ . repeat(' ', 44 - len(plugin) - (len(plug_status) - 6))
                \ . plug_status)
        endfor
      else
        call add(rst, '- ' . name . ':' . repeat(' ', 41 - len(name)) . status)
      endif
    endif
  endfor

  return rst
endfunction


