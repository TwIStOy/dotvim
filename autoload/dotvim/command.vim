function! dotvim#command#defineCommand() abort
  command! -nargs=+ -bar DepPlug call dotvim#plugin#reg(<args>)
  command! -nargs=+ -bar EnCrate call dotvim#crate#add(<args>)
endfunction

