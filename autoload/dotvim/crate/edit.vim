scriptencoding utf-8

let s:vars = get(s:, 'vars', {})

function! dotvim#crate#edit#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#edit#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('osyo-manga/vim-jplus', {
        \   'on_map' : '<Plug>(jplus'
        \ })
  call add(l:plugins, 'osyo-manga/vim-jplus')

  call add(l:plugins, 'tpope/vim-repeat')

  call add(l:plugins, 'ntpeters/vim-better-whitespace')

  call add(l:plugins, 'AndrewRadev/sideways.vim')

  return l:plugins
endfunction

function! dotvim#crate#edit#config() abort
  " osyo-manga/vim-jplus {{{
  nmap J <Plug>(jplus)
  vmap J <Plug>(jplus)
  " }}}

  " ntpeters/vim-better-whitespace {{{
  augroup WhiteSpaceHighlight
    autocmd FileType cpp hi ExtraWhitespace guifg=#FF2626 gui=underline ctermfg=124 cterm=underline
    autocmd FileType which_key DisableWhitespace
  augroup END
  let g:better_whitespace_enabled = 1
  let g:strip_whitespace_on_save = get(s:vars, 'strip_whitespace_on_save', 0)
  " }}}

  " AndrewRadev/sideways.vim {{{
  call dotvim#mapping#define_name('m', '+move/motion')
  call dotvim#mapping#define_leader('nnoremap', 'mh',
        \ ':SidewaysLeft<CR>', 'move-argument-left')
  call dotvim#mapping#define_leader('nnoremap', 'ml',
        \ ':SidewaysRight<CR>', 'move-argument-right')
  " }}}
endfunction

