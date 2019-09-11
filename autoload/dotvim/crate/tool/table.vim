function! dotvim#crate#tool#table#plugins() abort
  call dotvim#plug#reg('dhruvasagar/vim-table-mode', {
        \ 'on_cmd': ['TableModeEnable', 'TableModeToggle', 'TableModeRealign']
        \ })
  return [ 'dhruvasagar/vim-table-mode' ]
endfunction

function! dotvim#crate#tool#table#config() abort
  inoreabbrev <expr> <bar><bar>
            \ <SID>isAtStartOfLine('\|\|') ?
            \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>'
            \ : '<bar><bar>'
  inoreabbrev <expr> __
            \ <SID>isAtStartOfLine('__') ?
            \ '<c-o>:TableModeDisable<cr>' : '__'

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


