---@param keyword string
local todo_comment = function(keyword)
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local ls = require("luasnip")
  local f = ls.function_node

  return snippet {
    keyword,
    mode = "bw",
    nodes = {
      f(function()
        local CommentFt = require("Comment.ft")
        local CommentU = require("Comment.utils")
        local current_file = vim.fn.expand("%:p")
        local pattern = CommentFt.get(current_file, CommentU.ctype.linewise)
        if pattern == nil then
          -- keep the input
          pattern = "%s"
        end
        return pattern:format(" " .. keyword:upper() .. "(hawtian): ")
      end, {}),
    },
  }
end

return function()
  local quick_expand = require("ht.snippets.snippet").quick_expand

  return {
    quick_expand("shrug", "¯\\_(ツ)_/¯"),
    quick_expand("angry", "(╯°□°）╯︵ ┻━┻"),
    quick_expand("happy", "ヽ(´▽`)/"),
    quick_expand("sad", "(－‸ლ)"),
    quick_expand("confused", "(｡･ω･｡)"),

    todo_comment("todo"),
    todo_comment("fixme"),
    todo_comment("fucking"),
    todo_comment("note"),
  }
end
