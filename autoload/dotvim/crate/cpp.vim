let s:vars = get(s:, 'vars', {})

function! dotvim#crate#cpp#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction

function! dotvim#crate#cpp#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('octol/vim-cpp-enhanced-highlight', {
        \ 'on_ft': ['cpp']
        \ })
  call add(l:plugins, 'octol/vim-cpp-enhanced-highlight')

  return l:plugins
endfunction

function! dotvim#crate#cpp#config() abort
  let g:polyglot_disabled = get(g:, 'polyglot_disabled', [])

  call add(g:polyglot_disabled, 'c')
  call add(g:polyglot_disabled, 'cpp')

  let g:cpp_class_scope_highlight =
        \ get(s:vars, 'cpp_class_scope_highlight', 0)
  let g:cpp_member_variable_highlight =
        \ get(s:vars, 'cpp_member_variable_highlight', 0)
  let g:cpp_class_decl_highlight =
        \ get(s:vars, 'cpp_class_decl_highlight', 0)
  let g:cpp_experimental_template_highlight =
        \ get(s:vars, 'cpp_experimental_template_highlight', 0)
  let g:cpp_concepts_highlight =
        \ get(s:vars, 'cpp_concepts_highlight', 0)
  let g:cpp_no_function_highlight =
        \ get(s:vars, 'cpp_no_function_highlight', 0)
endfunction

