" Box is a new model to respect some vim plugins which have relative functions.
" dotvim will load and config them at the same time.
"
" Execute box steps:
"   1. Run config() before plugins loaded
"   2. Load plugins, register plugins into plugin manager(dein.vim)
"   3. Run PostConfig() after plugins loaded
"

" enabled boxes' name and settings
let s:enabled_boxes = get(s:, 'enabled_boxes', {})

function! dotvim#box#load(name, opt) abort
  if has_key(s:enabled_boxes, name)
    return
  endif

  if type(a:opt) == v:t_dict
    try
      call dotvim#box#{a:name}#set_var(a:opt)
      let s:enabled_boxes[a:name] = a:opt
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry
  endif
endfunction

" Entry point for module `Box`
function! dotvim#box#bootstrap() abort
  " setup dein
  execute 'set runtimepath+=' . g:_dotvim_dein_root .
        \ '/repos/github.com/Shougo/dein.vim'

  " Execute `config()` functions
  for box in s:enabled_boxes
    let g:dotvim_current_box = box

    call s:_box_function(box, 'config')
  endfor

  " Register plugins into plugin manager
  call dein#begin(g:_dotvim_dein_root)

  " builtin plugins
  call dein#add(g:_dotvim_dein_root . '/repos/github.com/Shougo/dein.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  " boxed plugins
  for box in s:enabled_boxes
    let g:dotvim_current_box = box

    for plugin in s:_box_function(box, 'plugins')
      if type(plugin) == v:t_string
        call dein#add(plugin)
        continue
      endif
      if type(plugin) == v:t_dict
        call dein#add(plugin.name, plugin.option)
        continue
      endif
      if type(plugin) == v:t_list
        if len(plugin) == 1
          call dein#add(plugin[0])
        else
          call dein#add(plugin[0], plugin[1])
        endif
      endif
    endfor
  endfor

  call dein#end()

  " Execute `post_config()` functions
  for box in s:enabled_boxes
    let g:dotvim_current_box = box

    call s:_box_function(box, 'post_config')
  endfor
endfunction


function! s:_box_function(box, func) abort
  let p = []
  try
    let p = dotvim#box#{a:box}#{a:func}()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction


