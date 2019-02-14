let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#table#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#tool#table#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'dhruvasagar/vim-table-mode')

  return l:plugins
endfunction

function! dotvim#crate#tool#table#config() abort
  inoreabbrev <expr> <bar><bar>
            \ <SID>isAtStartOfLine('\|\|') ?
            \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' 
            \ : '<bar><bar>'
  inoreabbrev <expr> __
            \ <SID>isAtStartOfLine('__') ?
            \ '<c-o>:silent! TableModeDisable<cr>' : '__'

  " default use markdown-compatible table
  let g:table_mode_corner='|'

  call dotvim#mapping#define_leader('nnoremap', 'tt',
        \ ':TableModeToggle<CR>', 'toggle-table-mode')

  call dotvim#mapping#define_leader('nnoremap', 'tr',
        \ ':TableModeRealign<CR>', 'table-mode-realign')
endfunction

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(
        \ substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') 
        \ . '\s*\v' . mapping_pattern . '\v$')
endfunction


