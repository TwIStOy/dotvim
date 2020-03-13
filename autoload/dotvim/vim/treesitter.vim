" auto register existing languages

let s:logger = dotvim#api#import('logging').getLogger('treesitter')

function! dotvim#vim#treesitter#register(lang) abort
lua << EOL
  name = vim.api.nvim_eval('a:lang')
  path = os.getenv("HOME") .. '/.tree-sitter/bin/' .. name .. '.so'
  vim.treesitter.require_language(name, path)
EOL
endfunction

function! dotvim#vim#treesitter#register_all() abort
  let l:list = split(system('ls ~/.tree-sitter/bin'), '\n')
  for l:name in l:list
    let l:lang = split(l:name, '\.')[0]
    call s:logger.info('Register Parser: ' . l:lang)
    call dotvim#vim#treesitter#register(l:lang)
  endfor
endfunction

function! dotvim#vim#treesitter#cpp() abort
lua << EOL
  local query = [[
    "for" @keyword
    "if" @keyword
    "return" @keyword

    (string_literal) @string
    (number_literal) @number
    (comment) @comment

    (preproc_function_def name: (identifier) @function)
  ]]

  highlighter = vim.treesitter.TSHighlighter.new(query)
EOL
endfunction

