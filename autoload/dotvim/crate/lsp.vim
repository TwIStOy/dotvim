let s:vars = get(s:, 'vars', {})

function! dotvim#crate#lsp#plugins() abort
  call dotvim#plugin#reg('neoclide/coc.nvim', {
        \ 'build': 'yarn install'
        \ })

  return ['neoclide/coc.nvim']
endfunction

function! dotvim#crate#lsp#config() abort
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
        \ ':call dotvim#crate#lsp#show_documentation()<CR>',
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
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  set cmdheight=2
  set shortmess+=c
  set signcolumn=yes
  set hidden
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! dotvim#crate#lsp#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#lsp#show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

