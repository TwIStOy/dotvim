return function()
  local snippet = require("ht.snippets.snippet").build_snippet
  local word_expand = require("ht.snippets.snippet").build_simple_word_snippet
  local ls = require("luasnip")
  local c = ls.choice_node
  local t = ls.text_node
  local f = ls.function_node
  local i = ls.insert_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local postfix = require("luasnip.extras.postfix").postfix

  return {
    postfix(".cs", {
      f(function(_, parent)
        -- switch name style from snake to pascal or vice versa
        local name = parent.snippet.env.POSTFIX_MATCH
        if name:match("^[A-Z]") then
          -- is pascal case now, change to snake case
          name = name:gsub("(%u+)(%u%l)", "%1_%2")
          name = name:gsub("([a-z0-9])([A-Z])", "%1_%2")
          name = name:gsub("-", "_")
          return name:lower()
        else
          -- is snake case now, change to pascal case
          return name
            :gsub("_(%l)", function(s)
              return s:upper()
            end)
            :gsub("^%l", string.upper)
            :gsub("_$", "")
        end
      end, {}),
    }),
  }
end
