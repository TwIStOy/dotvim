scriptencoding utf-8

let s:vars = get(s:, 'vars', {})

function! dotvim#crate#better#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#better#plugins() abort " {{{
  let l:plugins = []

  call add(l:plugins, 'tpope/vim-surround')

  call add(l:plugins, 'nvim-treesitter/nvim-treesitter')

  call add(l:plugins, ['Yggdroot/LeaderF', {
        \ 'on_cmd': ['Leaderf',
        \            "LeaderfFile",
        \            "LeaderfBuffer",
        \            "LeaderfBufferAll",
        \            "LeaderfMru",
        \            "LeaderfMruCwd",
        \            "LeaderfTag",
        \            "LeaderfBufTag",
        \            "LeaderfBufTagAll",
        \            "LeaderfFunction",
        \            "LeaderfFunctionAll",
        \            "LeaderfLine",
        \            "LeaderfLineAll",
        \            "LeaderfHistoryCmd",
        \            "LeaderfHistorySearch",
        \            "LeaderfSelf",
        \            "LeaderfHelp",
        \            "LeaderfColorscheme",
        \            "LeaderfRgInteractive",
        \            "LeaderfRgRecall"
        \           ],
        \ 'build': './install.sh',
        \ }])

  call add(l:plugins, 'tenfyzhong/axring.vim')

  call add(l:plugins, ['Yggdroot/indentLine', {
        \ 'on_ft': ['python']
        \ }])

  call add(l:plugins, ['godlygeek/tabular', {
        \ 'on_cmd': 'Tabularize'
        \ }])

  call add(l:plugins, ['junegunn/vim-easy-align', {
        \ 'on_cmd': ['<Plug>(EasyAlign)', 'EsayAlign']
        \ }])


  call add(l:plugins, 'itchyny/lightline.vim')
  call add(l:plugins, 'mengelbrecht/lightline-bufferline')

  call add(l:plugins, 'matze/vim-move')

  call add(l:plugins, 'MattesGroeger/vim-bookmarks')

  call add(l:plugins, 'farmergreg/vim-lastplace')

  call add(l:plugins, ['Asheq/close-buffers.vim', {
        \ 'on_cmd': 'Bdelete'
        \ }])

  call add(l:plugins, 'aperezdc/vim-template')

  call add(l:plugins, 'tomtom/tcomment_vim')

  " lazy group {{{
  call add(l:plugins, ['RRethy/vim-illuminate', { 'lazy': 1 }])
  call add(l:plugins, 'sheerun/vim-polyglot')
  call add(l:plugins, ['andymass/vim-matchup', { 'lazy': 1 }])
  " }}}

  return l:plugins
endfunction " }}}

function! dotvim#crate#better#config() abort " {{{
  " enable vim-surround default keybindings {{{
  let g:surround_no_mappings = 0
  let g:surround_no_insert_mappings = 1
  " }}}

  " leaderf settings {{{
  let g:Lf_ShortcutF = '<Leader>ff'
  let g:Lf_ShortcutB = '<Leader>ffb'
  let g:Lf_WindowPosition = 'popup'
  let g:Lf_RecurseSubmodules = 1

  let g:Lf_HideHelp = 1
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_DefaultExternalTool = ''
  let g:Lf_WorkingDirectoryMode = 'ac'
  let g:Lf_PopupPosition = [1, 0]
  let g:Lf_FollowLinks = 1
  let g:Lf_WildIgnore = {
        \   'dir': [
        \     '.git', '.svn', '.hg', '.cache', '.build',
        \     '.deps', '.third-party-build', 'build' ],
        \   'file': [
        \     '*.exe', '*.o', '*.a', '*.so', '*.py[co]',
        \     '*.sw?', '*.bak', '*.d', '*.idx', "*.lint",
        \     '*.gcno',
        \   ]
        \ }

  let g:Lf_PopupWidth = &columns * 3 / 4
  let g:Lf_PopupHeight = float2nr(&lines * 0.6)
  let g:Lf_PopupShowStatusline = 0
  let g:Lf_PreviewInPopup = 1
  let g:Lf_PopupPreviewPosition = 'bottom'
  let g:Lf_PreviewHorizontalPosition = 'right'
  let g:Lf_RootMarkers = get(s:vars, 'leaderf_root_markers', ['.git'])
  let g:Lf_WorkingDirectoryMode = 'A'

  augroup LeaderfResizeTrigger
    au!
    au VimResized * let g:Lf_PopupWidth = &columns * 3 / 4
                 \| let g:Lf_PopupHeight = float2nr(&lines * 0.6)
  augroup END

  let g:Lf_RememberLastSearch = 0
  " }}}

  if has_key(s:vars, 'axring_rings')
    let g:axring_rings = deepcopy(s:vars['axring_rings'])
  endif

  call dotvim#mapping#define_name('r', '+rg')

  " key mappings {{{
  call dotvim#mapping#define_leader('nnoremap', 'e',
        \ ':call dotvim#crate#better#leaderf_project_root()<CR>', 'edit[ pwd ]')
  nnoremap <silent><C-r> :call dotvim#crate#better#leaderf_project_root()<CR>

  call dotvim#mapping#define_leader('nnoremap', 'rg',
        \ ':LeaderfRgInteractive<CR>', 'rg')

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

  let g:lightline = {
        \ 'active': {
        \   'left':[ [ 'mode', 'paste' ], ['gitbranch', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ ['lineinfo'], ['filetype', 'fileencoding', 'percent'] ],
        \ },
        \ 'component': {
        \   'lineinfo': '%3l:%-2v',
        \ },
        \ 'component_function': {
        \   'gitbranch': 'fugitive#head',
        \ }
        \ }
  let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
  let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
  let g:lightline.component_type   = {'buffers': 'tabsel'}
  let g:lightline.separator = { 'left': '', 'right': '' }
  let g:lightline.subseparator = { 'left': '|', 'right': '|' }

  let g:move_key_modifier = 'C'

  " vim-illuminate {{{
  let g:Illuminate_delay = 200
  let g:Illuminate_ftblacklist = ['nerdtree', 'defx']
  " }}}

  " vim-bookmark {{{
  let g:bookmark_no_default_key_mappings = 1

  call dotvim#mapping#define_leader('nnoremap', 'bm', ':BookmarkToggle<CR>',
        \ 'toggle-bookmark')
  call dotvim#mapping#define_leader('nnoremap', 'bc', ':BookmarkClearAll<CR>',
        \ 'clear-all-bookmarks')
  call dotvim#mapping#define_leader('nnoremap', 'bn', ':BookmarkNext<CR>',
        \ 'next-bookmark')
  call dotvim#mapping#define_leader('nnoremap', 'bp', ':BookmarkPrev<CR>',
        \ 'previous-bookmark')
  " }}}

  " vim-template {{{
  let g:templates_directory = [ $HOME . '/.dotvim/vim-templates' ]
  let g:templates_no_autocmd = 0
  let g:templates_debug = 0
  let g:templates_no_builtin_templates = 1
  let g:templates_user_variables = get(g:, 'templates_user_variables', [])
  call extend(g:templates_user_variables, [
        \   [ 'GIT_USER',  'dotvim#utils#git_user' ],
        \   [ 'GIT_EMAIL', 'dotvim#utils#git_email' ],
        \   [ 'LAST_FOLDER', 'dotvim#crate#better#_last_folder_name' ],
        \ ])
  " }}}

  augroup BetterLeaderf
    autocmd!
    autocmd User LeaderfNeeded call dotvim#crate#better#_load_leaderf()
  augroup END

  " polyglot {{{
  let g:polyglot_disabled = get(g:, 'polyglot_disabled', [])

  " call add(g:polyglot_disabled, 'autoindent')

  for l:tp in get(s:vars, 'treesitter_enabled_languages', [])
    call add(g:polyglot_disabled, l:tp)
  endfor
  " }}}
endfunction " }}}

function! s:load_treesitter(tps)
lua <<EOF
   require'nvim-treesitter.configs'.setup {
     ensure_installed = vim.api.nvim_eval('a:tps'),
     highlight = {
       enable = true, -- false will disable the whole extension
       disable = {},  -- list of language that will be disabled
     },
   }
EOF
endfunction

function! dotvim#crate#better#postConfig() abort
  call timer_start(400, 'dotvim#crate#better#_lazy_load')

  call s:load_treesitter(get(s:vars, 'treesitter_enabled_languages', []))
endfunction

function! dotvim#crate#better#_lazy_load(timer) abort
  call dotvim#vim#plug#source(
        \ 'vim-matchup',
        \ 'vim-illuminate')
endfunction

function! dotvim#crate#better#_load_leaderf() abort
  if dein#is_sourced('LeaderF') == 0
    call dein#source('LeaderF')
  endif
endfunction

function! dotvim#crate#better#_last_folder_name() abort
  return expand("%:p:h:t")
endfunction

function! dotvim#crate#better#leaderf_project_root() abort
  if has_key(b:, '_dotvim_resolved_project_root')
    execute 'LeaderfFile ' . b:_dotvim_resolved_project_root
  else
    execute 'LeaderfFile'
  endif
endfunction

" vim:set foldmethod=marker ft=vim sw=2 sts=2 et:
