let s:vars = {}

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
        \ 'call dotvim#crate#lsp#show_documentation()',
        \ 'goto-doc')
  call dotvim#mapping#define_leader('nmap', 'gR',
        \ '<Plug>(coc-rename)', 'lsp-rename')

  if get(s:vars, 'coc_show_signature_help', 0)
    autocmd CursorHoldI,CursorMovedI * silent! call CocAction('showSignatureHelp')
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
  set signcolumn=yes
  set hidden

  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
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
    call CocAction('doHover')
  endif
endfunction
