let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lang#markdown#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lang#markdown#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('plasticboy/vim-markdown', {
        \ 'on_ft': ['markdown']
        \ })
  call add(l:plugins, 'plasticboy/vim-markdown')

  if get(s:vars, 'enable_preview', 0)
    call dotvim#plugin#reg('iamcco/markdown-preview.nvim', {
          \ 'on_ft': ['markdown'],
          \ 'build': 'sh -c "cd app && yarn install"'
          \ })
    call add(l:plugins, 'iamcco/markdown-preview.nvim')
  endif

  return l:plugins
endfunction


function! dotvim#crate#lang#markdown#config() abort
  let g:vim_markdown_folding_disabled = get(s:vars, 'folding_disabled', 1)
  let g:vim_markdown_no_default_key_mappings = 1

  let g:vim_markdown_conceal = get(s:vars, 'conceal', 0)

  if get(s:vars, 'enable_preview', 0)
    let g:mkdp_echo_preview_url = 1
    let g:mkdp_auto_start = get(s:vars, 'preview_auto_start', 1)
    let g:mkdp_open_to_the_world = 1
  endif

  if get(s:vars, 'math_enabled', 0)
    let g:tex_conceal = ""
    let g:vim_markdown_math = 1
  endif

  if get(s:vars, 'frontmatter_enabled', 0)
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
  endif
endfunction

