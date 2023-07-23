local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local quick_expand = ht_snippet.quick_expand
local postfix = require("ht.snippets.cpp.postfix").postfix
local i = ht_snippet.insert_node
local ls = require("luasnip")
local f = ls.function_node
local ts_postfix = require("ht.snippets.cpp.ts_postfix")
local ts_postfix_any_expr = ts_postfix.ts_postfix_any_expr
local ts_postfix_ident_only = ts_postfix.ts_postfix_ident_only

return {
  ts_postfix_ident_only(".cs", {
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

  -- postfixes
  ts_postfix_any_expr(".be", {
    f(function(_, parent)
      return ("std::begin(%s), std::end(%s)"):format(
        parent.snippet.env.POSTFIX_MATCH,
        parent.snippet.env.POSTFIX_MATCH
      )
    end, {}),
  }),
  ts_postfix_any_expr(".mv", {
    f(function(_, parent)
      return ("std::move(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  ts_postfix_any_expr(".fwd", {
    f(function(_, parent)
      return ("std::forward<decltype(%s)>(%s)"):format(
        parent.snippet.env.POSTFIX_MATCH,
        parent.snippet.env.POSTFIX_MATCH
      )
    end, {}),
  }),
  ts_postfix_any_expr(".val", {
    f(function(_, parent)
      return ("std::declval<%s>()"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  ts_postfix_any_expr(".uu", {
    f(function(_, parent)
      return ("(void)%s;"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
  ts_postfix_any_expr(".dt", {
    f(function(_, parent)
      return ("decltype(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
    end, {}),
  }),
}
