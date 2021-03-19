function! dotvim#crate#tool#git#plugins() abort
  call dotvim#plugin#reg('tpope/vim-fugitive', { 'lazy': 1 })
  call dotvim#plugin#reg('junegunn/gv.vim', {
        \ 'on_cmd': ['GV', 'GV!', 'GV?']
        \ })
  call dotvim#plugin#reg('rhysd/git-messenger.vim', {
        \ 'lazy' : 1,
        \ 'on_cmd' : 'GitMessenger',
        \ 'on_map' : '<Plug>(git-messenger',
        \ })

  return ['tpope/vim-fugitive', 'junegunn/gv.vim', 'airblade/vim-gitgutter',
        \ 'rhysd/git-messenger.vim', 'TwIStOy/conflict-resolve.nvim']
endfunction

function! dotvim#crate#tool#git#config() abort
  call dotvim#mapping#define_name('v', '+vcs/git')
  call dotvim#mapping#define_leader('nnoremap', 'vm',
        \ ':GitMessenger<CR>', 'check-git-message'
        \ )
  call dotvim#mapping#define_leader('nnoremap', 'v1',
        \ ':call conflict_resolve#ourselves()<CR>', 'diff-use-above'
        \ )
  call dotvim#mapping#define_leader('nnoremap', 'v2',
        \ ':call conflict_resolve#themselves()<CR>', 'diff-use-bottom'
        \ )
  call dotvim#mapping#define_leader('nnoremap', 'vb',
        \ ':call conflict_resolve#both()<CR>', 'diff-use-both'
        \ )

  " GitGutterSignsDisable
  let g:gitgutter_map_keys = 0
  let g:gitgutter_signs = 0
endfunction

function! dotvim#crate#tool#git#postConfig() abort
  call timer_start(600, 'dotvim#crate#tool#git#_lazy_load')
endfunction

function! dotvim#crate#tool#git#_lazy_load(timer) abort
  call dotvim#vim#plug#source('vim-fugitive')
endfunction


