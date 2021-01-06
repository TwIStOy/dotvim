let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#cpp#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#cpp#plugins() abort
  let l:plugins = []

  if get(s:vars, 'semantic_highlight', 0)
    if get(s:vars, 'standalone_semantic', 0)
      call add(l:plugins, ['arakashic/chromatica.nvim', {
            \ 'on_ft': ['cpp', 'c']
            \ }])
    else
      call add(l:plugins, ['jackguo380/vim-lsp-cxx-highlight', {
            \ 'on_ft': ['cpp', 'c']
            \ }])
    endif
  else
    if !get(s:vars, 'treesitter_highlight', 0)
      call add(l:plugins, ['bfrg/vim-cpp-modern', {
          \ 'on_ft': ['cpp', 'c']
          \ }])
    endif
  endif

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
  let g:polyglot_disabled = get(g:, 'polyglot_disabled', [])

  call add(g:polyglot_disabled, 'c')
  call add(g:polyglot_disabled, 'cpp')

  if get(s:vars, 'semantic_highlight', 0)
    if get(s:vars, 'standalone_semantic', 0)
      " settings for <chromatica>
      if has_key(s:vars, 'libclang_path')
        let g:chromatica#libclang_path = s:vars['libclang_path']
      endif
      let g:chromatica#enable_at_startup = 1
      let g:chromatica#responsive_mode = 1
    else
      " settings for <vim-lsp-cxx-highlight>
      autocmd VimEnter * hi LspCxxHlSymParameter cterm=underline gui=underline
    endif
  endif

  " vim-lsp-cxx {{{
  if has('nvim')
    let g:lsp_cxx_hl_use_nvim_text_props = 1
  else
    let g:lsp_cxx_hl_use_text_props = 1
  endif
  let g:lsp_cxx_hl_syntax_priority = 100
  " }}}


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
  nnoremap <buffer><silent><leader>fa :FSHere<CR>
  nnoremap <buffer><silent><leader>fv :FSSplitRight<CR>
  nnoremap <buffer><silent><leader>cd :call cpp_toolkit#mark_current_function_decl()<CR>
  nnoremap <buffer><silent><leader>pd :call cpp_toolkit#generate_function_define_here()<CR>
  inoremap <buffer><silent><c-e><c-i> <C-o>:LeaderfCppInclude<CR>

  setlocal foldexpr=dotvim#lang#cpp#foldExpr(v:lnum)

  execute 'CppToolkitCurrentRoot'
  let b:_dotvim_resolved_project_root = cpp_toolkit#project_root()
endfunction

