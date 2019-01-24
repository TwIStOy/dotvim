let s:enabled_crates = []
let s:available_crates = {}

let s:logger = dotvim#api#import('logging').getLogger('crate')

let s:crate_base = {
      \ 'name': '',
      \ 'category': '',
      \ 'dir': '',
      \ 'enabled': 0,
      \ 'vars': {}
      \ }

function! dotvim#crate#get() abort
  return s:enabled_crates
endfunction

function! dotvim#crate#add(...) abort
  if a:0 == 1
    if index(s:enabled_crates, a:crate) != -1
      return
    endif

    if has_key(s:available_crates, a:crate)
      call add(s:enabled_crates, a:crate)
      let s:available_crates[a:crate].enabled = 1
    endif
  else
    for a:l in a:000
      call dotvim#crate#add(a:l)
    endfor
  endif
endfunction

function! dotvim#crate#setVars(crate, key, value) abort
  if has_key(s:available_crates, a:crate)
    let s:available_crates[a:crate].vars[a:key] = a:value
  endif
endfunction

function! dotvim#crate#hasLoaded(name) abort
  return index(s:enabled_crates, a:name) != -1
endfunction

function! dotvim#crate#disable(name) abort
  let index = index(s:enabled_crates, a:name)
  if index != -1
    call remove(s:enabled_crates, index)
  endif
endfunction

function! dotvim#crate#readVars(name) abort
  if has_key(s:available_crates, a:name)
    return s:available_crates[a:name].vars
  else
    return {}
  endif
endfunction

function! dotvim#crate#loadConfig(...) abort
  if a:0 == 0
    for l:crate in s:enabled_crates
      call dotvim#crate#loadConfig(l:crate)
    endfor
  elseif a:0 == 1
    if has_key(s:available_crates, a:name)
      let l:config_file_path = s:available_crates[a:name].dir . '/config.vim'
      call dotvim#utils#source(l:config_file_path)
    else
      call s:logger.warn('Load config failed. Crate "' . l:crate . '" not found.')
    endif
  else
    for l:crate in a:000
      call dotvim#crate#loadConfig(l:crate)
    endfor
  endif
endfunction

function! dotvim#crate#loadPackages(...) abort
  if a:0 == 0
    for l:crate in s:enabled_crates
      call dotvim#crate#loadPackages(l:crate)
    endfor
  elseif a:0 == 1
    if has_key(s:available_crates, a:name)
      let l:package_file_path = s:available_crates[a:name].dir . '/package.vim'
      call dotvim#utils#source(l:package_file_path)
    else
      call s:logger.warn('Load packages failed. Crate "' . l:crate . '" not found.')
    endif
  else
    for l:crate in a:000
      call dotvim#crate#loadPackages(l:crate)
    endfor
  endif
endfunction

function! dotvim#crate#initialize(root_dir) abort
  let l:crate_category_dirs = filter(split(globpath(a:root_dir, '*'), '\n'),
        \ 'isdirectory(v:val)')

  let l:crates_category = deepcopy(l:crate_category_dirs)

  for l:category in l:crates_category
    let l:category_name = fnamemodify(l:category, ':t')
    let l:crate_full_dir = split(globpath(l:category, '*'), '\n')

    for l:crate in l:crate_full_dir
      let l:crate_name = fnamemodify(l:crate, ':t')
      let s:available_crates[l:crate_name] = deepcopy(s:crate_base)
      let s:available_crates[l:crate_name].name = l:crate_name
      let s:available_crates[l:crate_name].category = l:category_name
      let s:available_crates[l:crate_name].dir = l:crate
    endfor

    let l:crate_dirs = deepcopy(l:crate_full_dir)
    let l:crate_names = map(l:crate_dirs, 'fnamemodify(v:val, ":t")')
    call s:logger.info('Found crates ' . string(l:crate_names) . ' at ' . string(l:category))
  endfor
endfunction

function! dotvim#crate#listCrates() abort
  tabnew dotvimCrates
  nnoremap <buffer> q :q<cr>
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist
  setlocal noswapfile nowrap cursorline nospell
  setf dotvimCrateManager
  nnoremap <silent> <buffer> q :bd<CR>
  let info = [
        \ 'dotvim.Crates:',
        \ '',
        \ ]

  " TODO(hawtian): fix list crates hints
  for l in s:enabled_crates
    call add(info,  l)
  endfor

  call setline(1, info)
  setl nomodifiable
endfunction

