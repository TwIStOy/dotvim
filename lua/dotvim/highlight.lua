module('dotvim.highlight', package.seeall)

function LoadTreesitter()
  local query = [[
    "for"    @keyword
    "if"     @keyword
    "return" @keyword
    "decltype" @keyword
    "mutable" @keyword
    "constexpr" @keyword
    "class" @keyword

    (auto) @keyword
    (string_literal) @string
    (number_literal) @number
    (comment) @comment

    (preproc_def name: (identifier) @function)
    (preproc_function_def name: (identifier) @function)
  ]]

  vim.treesitter.add_language("/home/hawtian/tools/tree-sitter-build/bin/cpp.so", "cpp")
  highlighter = vim.treesitter.TSHighlighter.new(query)
end

