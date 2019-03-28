augroup DotvimBuiltinDefx
  au!
  autocmd FileType defx call s:defx_window_init()
augroup END

function! s:defx_window_init() abort
  setl nonumber
  setl norelativenumber
  setl listchars=
  setl nofoldenable
  setl foldmethod=manual

  silent! nunmap <buffer> <Space>
  silent! nunmap <buffer> <C-l>
  silent! nunmap <buffer> <C-j>
  silent! nunmap <buffer> E
  silent! nunmap <buffer> gr
  silent! nunmap <buffer> gf
  silent! nunmap <buffer> -
  silent! nunmap <buffer> s

  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') : defx#do_action('drop')
  nnoremap <silent><buffer><expr> vv
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') : defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> vs
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') : defx#do_action('drop', 'split')
  nnoremap <silent><buffer><expr> vt
        \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') : defx#do_action('drop', 'tabedit')

  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')

  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> l
        \ defx#is_directory() ?
        \ defx#do_action('open') : defx#do_action('drop')

  let s:git_home = system('git rev-parse --show-toplevel')
  nnoremap <silent><buffer><expr> gh
        \ defx#do_action('call', 'Defx_smart_home')

  nnoremap <silent><buffer><expr> zo
        \ defx#do_action('open_tree_recursive')

  nnoremap <silent><buffer><expr> c       defx#do_action('copy')
  nnoremap <silent><buffer><expr> m       defx#do_action('move')
  nnoremap <silent><buffer><expr> p       defx#do_action('paste')

  nnoremap <silent><buffer><expr> K       defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N       defx#do_action('new_file')
  nnoremap <silent><buffer><expr> C       defx#do_action('toggle_columns', 'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S       defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d       defx#do_action('remove')
  nnoremap <silent><buffer><expr> r       defx#do_action('rename')
  nnoremap <silent><buffer><expr> yy      defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> ;       defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> q       defx#do_action('quit')
  nnoremap <silent><buffer><expr> ~       defx#do_action('cd')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *       defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> <C-l>   defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>   defx#do_action('print')
endfunction

function! Defx_smart_home(_) abort
  let l:path = dotvim#utils#repo_home()
  echo 'Git Repo Home: ' . l:path
  call defx#call_action('change_vim_cwd', [l:path])
  return defx#call_action('cd', [l:path])
endfunction

