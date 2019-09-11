let g:_log_file_path = get(g:, 'dotvim_log_file_path', $HOME . '/.dotvim.log')
let g:_dotvim_minlvl = get(g:, '_dotvim_minlvl', 0)

let s:loggers = {}

let s:logger_base = {
      \ 'name': '',
      \ 'debug': function('dotvim#api#logging#log_debug'),
      \ 'info': function('dotvim#api#logging#log_info'),
      \ 'warn': function('dotvim#api#logging#log_warn'),
      \ 'error': function('dotvim#api#logging#log_error')
      \ }

let s:levels = {
      \ 1: 'Debug',
      \ 2: 'Info ',
      \ 3: 'Warn ',
      \ 4: 'Error'
      \ }

let s:self = {}

function! dotvim#api#logging#get() abort
  return deepcopy(s:self)
endfunction

function! s:self.getLogger(name) abort
  if has_key(s:loggers, a:name)
    return s:loggers[a:name]
  endif

  let s:loggers[a:name] = deepcopy(s:logger_base)
  let s:loggers[a:name].name = a:name
  return s:loggers[a:name]
endfunction

function! dotvim#api#logging#log_enabled(lvl)
  return a:lvl > g:_dotvim_minlvl
endfunction

function! dotvim#api#logging#log_debug(msg) dict
  call s:log_impl(a:msg, 1, self.name)
endfunction

function! dotvim#api#logging#log_info(msg) dict
  call s:log_impl(a:msg, 2, self.name)
endfunction

function! dotvim#api#logging#log_warn(msg) dict
  call s:log_impl(a:msg, 3, self.name)
endfunction

function! dotvim#api#logging#log_error(msg) dict
  call s:log_impl(a:msg, 4, self.name)
endfunction

function! s:log_impl(msg, tag, name) abort
  if !dotvim#api#logging#log_enabled(a:tag)
    return
  endif
  let l:lines = []

  call add(l:lines, s:parse_tag(a:tag))
  call add(l:lines, a:name)
  call add(l:lines, s:parse_time('%c'))
  call add(l:lines, s:parse_msg(a:msg))

  let l:write_line = join(l:lines, ' ')
  if has('nvim')
    call s:write_nvim(l:write_line)
  else
    call s:write_vim(l:write_line)
  endif
endfunction

function! s:write_vim(line) abort
lua << EOL
  fout = io.open(vim.eval('g:_log_file_path'), 'a')
  if fout == nil then
    return
  end
  fout:write(vim.eval('a:line') .. '\n')
  fout:close()
EOL
endfunction

function! s:write_nvim(line) abort
lua << EOL
  fout = io.open(vim.api.nvim_eval('g:_log_file_path'), 'a')
  if fout == nil then
    return
  end
  fout:write(vim.api.nvim_eval('a:line') .. '\n')
  fout:close()
EOL
endfunction

function! s:parse_time(format)
  let l:time = strftime(a:format)
  return s:sandwitch_brackets(l:time)
endfunction

function! s:parse_tag(tag)
  return has_key(s:levels, a:tag) ?
        \ s:sandwitch_brackets(s:levels[a:tag]) : ''
endfunction

function! s:parse_msg(msg)
  let l:msg = substitute(a:msg, '^\"', '', 'g')
  return substitute(l:msg, '\"$', '', 'g')
endfunction

function! s:sandwitch_brackets(val)
  return '[' . a:val . ']'
endfunction

