scriptencoding utf-8

let s:vars = get(s:, 'vars', {})

function! dotvim#crate#better#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#better#plugins() abort
  let l:plugins = []

  call add(l:plugins, 'tpope/vim-surround')

  call dotvim#plugin#reg('Yggdroot/LeaderF', {
        \ 'on_cmd': ['Leaderf', 'LeaderfMru', 'LeaderfBuffer'],
        \ 'build': './install.sh'
        \ })
  call add(l:plugins, 'Yggdroot/LeaderF')

  call add(l:plugins, 'tenfyzhong/axring.vim')

  call add(l:plugins, 'bogado/file-line')

  call add(l:plugins, 'Yggdroot/indentLine')

  call dotvim#plugin#reg('godlygeek/tabular', {
        \ 'on_cmd': 'Tabularize'
        \ })
  call add(l:plugins, 'godlygeek/tabular')

  call dotvim#plugin#reg('junegunn/vim-easy-align', {
        \ 'on_cmd': ['<Plug>(EasyAlign)', 'EsayAlign']
        \ })
  call add(l:plugins, 'junegunn/vim-easy-align')


  call add(l:plugins, 'itchyny/lightline.vim')
  call add(l:plugins, 'mengelbrecht/lightline-bufferline')

  call add(l:plugins, 'matze/vim-move')


  " lazy group {{{
  call dotvim#plugin#reg('RRethy/vim-illuminate', { 'lazy': 1 })
  call add(l:plugins, 'RRethy/vim-illuminate')

  call dotvim#plugin#reg('sheerun/vim-polyglot', { 'lazy': 1 })
  call add(l:plugins, 'sheerun/vim-polyglot')

  call dotvim#plugin#reg('luochen1990/rainbow', { 'lazy': 1 })
  call add(l:plugins, 'luochen1990/rainbow')

  call dotvim#plugin#reg('andymass/vim-matchup', { 'lazy': 1 })
  call add(l:plugins, 'andymass/vim-matchup')
  " }}}

  if get(s:vars, 'enable_defx_icons', 0)
    call dotvim#plugin#reg('kristijanhusak/defx-icons', {
          \ 'on_cmd': ['Defx']
          \ })
    call add(l:plugins, 'kristijanhusak/defx-icons')
  endif

  return l:plugins
endfunction

function! dotvim#crate#better#config() abort " {{{
  " enable vim-surround default keybindings {{{
  let g:surround_no_mappings = 0
  let g:surround_no_insert_mappings = 1
  " }}}

  let g:Lf_ShortcutF = '<Leader>ff'
  let g:Lf_ShortcutB = '<Leader>ffb'

  if has_key(s:vars, 'axring_rings')
    let g:axring_rings = deepcopy(s:vars['axring_rings'])
  endif

  call dotvim#mapping#define_name('b', '+buffer')
  call dotvim#mapping#define_name('r', '+rg')

  " key mappings {{{
  call dotvim#mapping#define_leader('nnoremap', 'e',
        \ ':Leaderf file<CR>', 'edit[ pwd ]')
  call dotvim#mapping#define_leader('nnoremap', 'ff',
        \ ':Leaderf file ~<CR>', 'edit[ $HOME ]')
  call dotvim#mapping#define_leader('nnoremap', 'fr',
        \ ':LeaderfMru<CR>', 'edit-recent-file')
  call dotvim#mapping#define_leader('nnoremap', 'bb',
        \ ':LeaderfBuffer<CR>', 'buffer-list')
  call dotvim#mapping#define_leader('nnoremap', 'rg',
        \ ':Leaderf rg --vimgrep<CR>', 'rg')

  call dotvim#mapping#define_leader('xmap', 'ta',
        \ ':EasyAlign<CR>', 'easy-align')
  call dotvim#mapping#define_leader('nmap', 'ta',
        \ ':EasyAlign<CR>', 'easy-align')
  " }}}

  set showtabline=2
  set guioptions-=e

  " disable --INSERT-- mode show
  set noshowmode

  if has_key(s:vars, 'use_clipboard')
    execute 'set clipboard=' . s:vars['use_clipboard']
  endif

  if get(s:vars, 'enable_defx_icons', 0)
    let g:defx_icons_enable_syntax_highlight = 1
    let defx_cmd  = ':Defx '
    let defx_cmd .= '-split=vertical -columns=icons:filename:type '
    let defx_cmd .= '-winwidth=30 -toggle<CR>'
    call dotvim#mapping#define_leader('nnoremap', 'ft',
          \ defx_cmd,
          \ 'toggle-file-explorer-with-icon')
  endif

  let g:lightline = {
        \ 'active': {
        \   'left':[ [ 'mode', 'paste' ], ['gitbranch', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component': {
        \   'lineinfo': ' %3l:%-2v',
        \ },
        \ 'component_function': {
        \   'gitbranch': 'fugitive#head',
        \ }
        \ }
  let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
  let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
  let g:lightline.component_type   = {'buffers': 'tabsel'}
  let g:lightline.separator = { 'left': '', 'right': '' }
  let g:lightline.subseparator = { 'left': '', 'right': '' }

  let g:move_key_modifier = 'C'

  " vim-illuminate {{{
  let g:Illuminate_delay = 200
  let g:Illuminate_ftblacklist = ['nerdtree', 'defx']
  " }}}
endfunction " }}}

function! dotvim#crate#better#postConfig() abort
  call timer_start(400, 'dotvim#crate#better#_lazy_load')
endfunction

function! dotvim#crate#better#_lazy_load(timer) abort
  call dotvim#vim#plug#source(
        \ 'vim-polyglot',
        \ 'vim-matchup',
        \ 'rainbow',
        \ 'vim-illuminate')
endfunction

" vim:set foldmethod=marker ft=vim sw=2 sts=2 et:
