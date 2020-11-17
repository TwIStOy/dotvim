let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#cpp#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#cpp#plugins() abort
  let l:plugins = []

  if get(s:vars, 'semantic_highlight', 0)
    if get(s:vars, 'standalone_semantic', 0)
      call dotvim#plugin#reg('arakashic/chromatica.nvim', {
            \ 'on_ft': ['cpp', 'c']
            \ })
      call add(l:plugins, 'arakashic/chromatica.nvim')
    else
      call dotvim#plugin#reg('jackguo380/vim-lsp-cxx-highlight', {
            \ 'on_ft': ['cpp', 'c']
            \ })
      call add(l:plugins, 'jackguo380/vim-lsp-cxx-highlight')
    endif
  else
    if get(s:vars, 'treesitter_highlight', 0)
      call add(l:plugins, 'nvim-treesitter/nvim-treesitter')
    else
      call dotvim#plugin#reg('bfrg/vim-cpp-modern', {
          \ 'on_ft': ['cpp', 'c']
          \ })
      call add(l:plugins, 'bfrg/vim-cpp-modern')
    endif
  endif

  call dotvim#plugin#reg('derekwyatt/vim-fswitch', {
        \ 'on_ft': ['cpp', 'c']
        \ })
  call add(l:plugins, 'derekwyatt/vim-fswitch')

  call dotvim#plugin#reg('luochen1990/rainbow', {
        \ 'on_ft': ['cpp']
        \ })
  call add(l:plugins, 'luochen1990/rainbow')

  call dotvim#plugin#reg('TwIStOy/leaderf-cppinclude', {
        \ 'lazy': 1,
        \ 'on_cmd': ['LeaderfCppInclude'],
        \ 'hook_source': 'execute "doautocmd User LeaderfNeeded"',
        \ })
  call add(l:plugins, 'TwIStOy/leaderf-cppinclude')

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

  augroup dotvimLangCppCommand
    autocmd!
    autocmd FileType c,cpp call s:do_cpp()
  augroup END

  let content = [
        \   [ "&Fuzzy Include", 'LeaderfCppInclude' ],
        \   [ "&ClangFormat", 'ClangFormat' ],
        \ ]
  call dotvim#quickui#append_context_menu(content, 'cpp')

  " clang-format settings for neoformat
  if has_key(s:vars, 'clang_format_exe')
    source $HOME/.dotvim/autoload/neoformat/formatters/cpp.vim
    let g:_dotvim_clang_format_exe = s:vars['clang_format_exe']
    let g:neoformat_enabled_cpp = ['myclangformat']
  endif
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

function! s:do_cpp() abort
  call dotvim#mapping#define_leader('nnoremap', 'fa', ':FSHere<CR>',
        \ 'switch-file-here')
  call dotvim#mapping#define_leader('nnoremap', 'fi', ':LeaderfCppInclude<CR>',
        \ 'include-cpp-header-here')
  call dotvim#mapping#define_leader('nnoremap', 'fv', ':FSSplitRight<CR>',
        \ 'switch-file-split-right')
  inoremap <silent><c-e><c-i> <C-o>:LeaderfCppInclude<CR>

  setlocal foldexpr=dotvim#lang#cpp#foldExpr(v:lnum)
endfunction

function! s:HandleLSPResponse(error, response) abort
  if empty(a:error)
    echo a:response
  else
    echo a:error
  endif
endfunction

function! dotvim#crate#lang#cpp#test() abort
  echo CocRequest('clangd', 'textDocument/switchSourceHeader', {
        \ "uri": "file://" . expand("%:p")
        \ })
endfunction

