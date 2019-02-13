let s:vars = get(s:, 'vars', {})

function! dotvim#crate#markdown#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#markdown#plugins() abort
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

  call add(l:plugins, 'dhruvasagar/vim-table-mode')

  return l:plugins
endfunction


function! dotvim#crate#markdown#config() abort
  inoreabbrev <expr> <bar><bar>
            \ <SID>isAtStartOfLine('\|\|') ?
            \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
  inoreabbrev <expr> __
            \ <SID>isAtStartOfLine('__') ?
            \ '<c-o>:silent! TableModeDisable<cr>' : '__'

  " default use markdown-compatible table
  let g:table_mode_corner='|'

  call dotvim#mapping#define_leader('nnoremap', 'tt',
        \ ':TableModeToggle<CR>', 'toggle-table-mode')

  call dotvim#mapping#define_leader('nnoremap', 'tr',
        \ ':TableModeRealign<CR>', 'table-mode-realign')

  let g:vim_markdown_folding_disabled = get(s:vars, 'folding_disabled', 1)
  let g:vim_markdown_no_default_key_mappings = 1

  let g:vim_markdown_conceal = get(s:vars, 'conceal', 0)

  if get(s:vars, 'math_enabled', 0)
    let g:tex_conceal = ""
    let g:vim_markdown_math = 1
  endif

  if get(s:vars, 'frontmatter_enabled', 0)
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
  endif
endfunction

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction
