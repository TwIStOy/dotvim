let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#cpp#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#cpp#plugins() abort
  let l:plugins = []

  call add(l:plugins, ['derekwyatt/vim-fswitch', {
        \ 'on_ft': ['cpp', 'c']
        \ }])

  call add(l:plugins, ['TwIStOy/vim-cpp-toolkit', {
        \ 'lazy': 1,
        \ 'on_cmd': ['LeaderfHeaderFiles', 'CppToolkitCurrentRoot'],
        \ 'on_func': ['cpp_toolkit#project_root'],
        \ 'hook_source': 'execute "doautocmd User LeaderfNeeded"',
        \ }])

  call add(l:plugins, ['luochen1990/rainbow', {
        \ 'on_ft': ['cpp']
        \ }])

  call add(l:plugins, ['TwIStOy/leaderf-cppinclude', {
        \ 'lazy': 1,
        \ 'on_cmd': ['LeaderfCppInclude'],
        \ 'hook_source': 'execute "doautocmd User LeaderfNeeded"',
        \ }])

  return l:plugins
endfunction

function! dotvim#crate#lang#cpp#config() abort
  " vim-cpp-toolkit {{{
  if has_key(s:vars, 'clang_library')
    let g:cpp_toolkit_clang_library = get(s:vars, 'clang_library')
  endif
  if has_key(s:vars, 'project_marker')
    let g:cpp_toolkit_project_marker = get(s:vars, 'project_marker')
  endif
  " }}}

  augroup dotvimLangCppCommand
    autocmd!
    autocmd FileType c,cpp call s:do_cpp()
  augroup END

  call dotvim#mapping#add_desc('cpp', 'fa', 'switch-file-here')
  call dotvim#mapping#add_desc('cpp', 'fv', 'switch-file-split-right')
  call dotvim#mapping#add_desc('cpp', 'cd', 'copy-function-decl')
  call dotvim#mapping#add_desc('cpp', 'pd', 'paste-function-def')

  let content = [
        \   [ "Fuzzy &Include", 'LeaderfCppInclude' ],
        \   [ "&Copy Function Decl\t<leader>cd",
        \     'call cpp_toolkit#mark_current_function_decl()'],
        \   [ "&Paste Function Def\t<leader>pd",
        \     'call cpp_toolkit#generate_function_define_here()']
        \ ]
  call dotvim#quickui#append_context_menu(content, 'cpp')

  " clang-format settings for neoformat
  if has_key(s:vars, 'clang_format_exe')
    source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim
    let g:_dotvim_clang_format_exe = s:vars['clang_format_exe']
    let g:neoformat_enabled_cpp = ['myclangformat']
  endif

  let g:templates_user_variables = get(g:, 'templates_user_variables', [])
  call add(g:templates_user_variables, [
        \  'PROJECT_HEADER', 'dotvim#crate#lang#cpp#header_filename' ])
endfunction

function! dotvim#crate#lang#cpp#postConfig()
  if get(s:vars, 'treesitter_highlight', 0)
    call s:load_cpp_treesitter()
  endif
endfunction

function! s:load_cpp_treesitter()
lua <<EOF
   require'nvim-treesitter.configs'.setup {
     ensure_installed = "cpp",
     highlight = {
       enable = true, -- false will disable the whole extension
       disable = {},  -- list of language that will be disabled
     },
   }
EOF
endfunction

function! dotvim#crate#lang#cpp#header_filename()
  let res = cpp_toolkit#corresponding_file()
  if len(res) == 0
    return 'NO HEADER FOUND!'
  else
    return res[0]
  endif
endfunction

function! s:do_cpp() abort
  if get(b:, '_dotvim_cpp_done', 0)
    return
  endif

  nnoremap <buffer><silent><leader>fa :FSHere<CR>
  nnoremap <buffer><silent><leader>fv :FSSplitRight<CR>
  nnoremap <buffer><silent><leader>cd :call cpp_toolkit#mark_current_function_decl()<CR>
  nnoremap <buffer><silent><leader>pd :call cpp_toolkit#generate_function_define_here()<CR>
  inoremap <buffer><silent><c-e><c-i> <C-o>:LeaderfCppInclude<CR>

  setlocal foldexpr=dotvim#lang#cpp#foldExpr(v:lnum)

  execute 'CppToolkitCurrentRoot'
  let b:_dotvim_resolved_project_root = cpp_toolkit#project_root()
  let b:_dotvim_cpp_done = 1
endfunction

