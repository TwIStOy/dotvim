let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lsp#coc#plugins() abort
  call dotvim#plugin#reg('neoclide/coc.nvim', {
        \ 'build': 'yarn install'
        \ })

  let l:plugins = ['neoclide/coc.nvim']
  if get(s:vars, 'vista_enabled', 0)
    call add(l:plugins, 'liuchengxu/vista.vim')
  endif

  return l:plugins
endfunction

function! dotvim#crate#lsp#coc#config() abort
  call dotvim#mapping#define_name('g', '+goto/lsp')

  call dotvim#mapping#define_leader('nmap', 'ga', '<Plug>(coc-codeaction)',
        \ 'lsp-codeaction')
  call dotvim#mapping#define_leader('nmap', 'gd', '<Plug>(coc-definition)',
        \ 'goto-definition')
  call dotvim#mapping#define_leader('nmap', 'gy', '<Plug>(coc-type-definition)',
        \ 'goto-type-def')
  call dotvim#mapping#define_leader('nmap', 'gi', '<Plug>(coc-implementation)',
        \ 'goto-implementation')
  call dotvim#mapping#define_leader('nmap', 'gr', '<Plug>(coc-references)',
        \ 'goto-references')
  call dotvim#mapping#define_leader('nnoremap', 'gk',
        \ ':call dotvim#crate#lsp#coc#show_documentation()<CR>',
        \ 'goto-doc')
  call dotvim#mapping#define_leader('nmap', 'gR',
        \ '<Plug>(coc-rename)', 'lsp-rename')
  call dotvim#mapping#define_leader('nmap', 'gf',
        \ '<Plug>(coc-fix-current)', 'fix-current-line')

  call dotvim#mapping#define_name('l', '+list/search')
  call dotvim#mapping#define_leader('nnoremap', 'ld',
        \ ':<C-u>CocList diagnostics<CR>', 'list-diagnostics')
  call dotvim#mapping#define_leader('nnoremap', 'lo',
        \ ':<C-u>CocList outline<CR>', 'list-outline')
  call dotvim#mapping#define_leader('nnoremap', 'ld',
        \ ':<C-u>CocList -I symbols<CR>', 'list-symbols')
  call dotvim#mapping#define_leader('nnoremap', 'ln',
        \ ':<C-u>CocNext<CR>', 'list-next')
  call dotvim#mapping#define_leader('nnoremap', 'lp',
        \ ':<C-u>CocPrev<CR>', 'list-prev')
  call dotvim#mapping#define_leader('nnoremap', 'lr',
        \ ':<C-u>CocListResume<CR>', 'list-resume')

  if get(s:vars, 'coc_show_signature_help', 0)
    autocmd CursorHoldI,CursorMovedI * silent! call CocActionAsync('showSignatureHelp')
  endif

  if get(s:vars, 'coc_cursorhold_highlight', 0)
    autocmd CursorHold * silent call CocActionAsync('highlight')
  endif

  let g:coc_start_at_startup = get(s:vars, 'coc_start_at_startup', 0)

  if has_key(s:vars, 'updatetime')
    let l:new_updatetime = str2nr(s:vars['updatetime'])
    execute 'set updatetime=' . l:new_updatetime
  endif

  " Close preview window when completion is done
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  let g:UltiSnipsEditSplit = "vertical"
  let g:UltiSnipsExpandTrigger="<c-f>"
  let g:UltiSnipsJumpForwardTrigger="<c-f>"
  let g:UltiSnipsJumpBackwardTrigger="<c-b>"
  let g:coc_snippet_next = "<C-f>"
  let g:coc_snippet_prev = "<C-b>"

  nmap <silent> [c <plug>(coc-diagnostic-prev)
  nmap <silent> ]c <plug>(coc-diagnostic-prev)

  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" : "\<TAB>"

  inoremap <silent><expr> <C-n>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<C-n>" :
        \ coc#refresh()

  " default extensions
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-ultisnips',
        \ 'coc-tsserver'
        \ ]

  " default settings
  let g:coc_user_config = {
        \ 'suggest.triggerAfterInsertEnter': v:false,
        \ 'diagnostic.enable': v:true,
        \ 'diagnostic.virtualText': v:false,
        \ 'diagnostic.messageTarget': 'float',
        \ 'signature.hideOnTextChange': v:true,
        \ 'signature.preferShowAbove': v:false,
				\ 'signature.target': 'float',
        \ 'list.insertMappings': {
        \   '<C-j>': 'normal:j',
        \   '<C-k>': 'normal:k'
        \ },
        \ 'list.normalMappings': {
        \   '<C-j>': 'normal:j',
        \   '<C-k>': 'normal:k'
        \ }
        \ }


  set cmdheight=2
  set shortmess+=c
  set signcolumn=yes
  set hidden

  " liuchengxu/vista.vim {{{

  if get(s:vars, 'vista_enabled', 0)
    let win = dotvim#api#import('window')
    call win.addAutocloseType('vista')

    let g:vista_sidebar_position = 'vertical botright'
    let g:vista_sidebar_width = 35
    let g:vista_echo_cursor = 0
    let g:vista_cursor_delay = 400
    let g:vista_close_on_jump = 0
    let g:vista_stay_on_open = 1
    let g:vista_blink = [2, 100]
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
    let g:vista_default_executive = 'coc'
    let g:vista_fzf_preview = ['right:50%']
    let g:vista_finder_alternative_executives = ['coc']
  endif

  " }}}
endfunction

function! dotvim#crate#lsp#coc#postConfig() abort
  if exists('g:lightline')
    call timer_start(500, 'dotvim#crate#lsp#coc#_lazy_start')

    let g:lightline.component_function['cocstatus'] = 'coc#status'

    if get(s:vars, 'vista_enabled', 0)
      let g:lightline.component_function['vista'] =
            \ 'dotvim#crate#lsp#coc#_NearestMethodOrFunction'
      let g:lightline.active.left[1] = extend(['cocstatus', 'vista'],
            \ g:lightline.active.left[1])
    endif
  endif
endfunction

function! dotvim#crate#lsp#coc#_lazy_start(timer) abort
  if get(s:vars, 'vista_enabled', 0)
    call vista#RunForNearestMethodOrFunction()
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! dotvim#crate#lsp#coc#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lsp#coc#show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

function! dotvim#crate#lsp#coc#_NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

