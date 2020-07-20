function! dotvim#crate#lang#rust#config() abort
  augroup dotvimLangRustCommand
    autocmd!
    autocmd FileType rust call s:do_keybindings()
  augroup END
endfunction

function! dotvim#crate#lang#rust#plugins() abort
  return ["rust-lang/rust.vim"]
endfunction

function! s:do_keybindings() abort
  call dotvim#mapping#define_leader('nnoremap', 'fc', ':RustFmt<CR>',
        \ 'rustfmt')
endfunction

