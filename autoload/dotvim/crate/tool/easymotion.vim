let s:vars = get(s:, 'vars', {})

function! dotvim#crate#tool#easymotion#setVariables(vars) abort
  let s:vars = deepcopy(a:vars)
endfunction


function! dotvim#crate#tool#easymotion#plugins() abort
  let l:plugins = []

  call dotvim#plugin#reg('easymotion/vim-easymotion', {
        \ 'on_map': '<Plug>(easymotion'
        \ })
  call add(l:plugins, 'easymotion/vim-easymotion')

  return l:plugins
endfunction

function! dotvim#crate#tool#easymotion#config() abort
  let g:EasyMotion_leader_key = get(s:vars, 'easymotion_leader_key', '\')

  call dotvim#mapping#define_leader('nmap', 'mf',
        \ '<Plug>(easymotion-bd-f)',
        \ 'motion-f'
        \ )
  call dotvim#mapping#define_leader('nmap', 'mu',
        \ '<Plug>(easymotion-bd-jk)',
        \ 'motion-line'
        \ )
  call dotvim#mapping#define_leader('nmap', 'mw',
        \ '<Plug>(easymotion-bd-w)',
        \ 'motion-word'
        \ )

  call dotvim#mapping#define_name('mw', '+motion-overwin')
  call dotvim#mapping#define_leader('nmap', 'mwf',
        \ '<Plug>(easymotion-overwin-f)',
        \ 'motion-overwin-f'
        \ )

  call dotvim#mapping#define_leader('nmap', 'mws',
        \ '<Plug>(easymotion-overwin-f2)',
        \ 'motion-overwin-f2'
        \ )

  call dotvim#mapping#define_leader('nmap', 'mwu',
        \ '<Plug>(easymotion-overwin-line)',
        \ 'motion-overwin-line'
        \ )

  call dotvim#mapping#define_leader('nmap', 'mww',
        \ '<Plug>(easymotion-overwin-w)',
        \ 'motion-overwin-word'
        \ )
endfunction

