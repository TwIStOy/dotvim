local ht_snippet = require("ht.snippets.snippet")
local ls = require("luasnip")
local i = ht_snippet.insert_node
local c = ht_snippet.choice_node
local t = ls.text_node
local f = ls.function_node
local ts_postfix = require("ht.snippets.cpp.ts_postfix")
local ts_postfix_any_expr = ts_postfix.ts_postfix_any_expr
local ts_postfix_ident_only = ts_postfix.ts_postfix_ident_only
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

return {
  ts_postfix_ident_only {
    ".cs",
    name = "cs",
    dscr = "Toggle case style",
    nodes = {
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
    },
  },

  ts_postfix_any_expr {
    ".be",
    name = "begin..end",
    dscr = "Completes a variable with both begin() and end().",
    nodes = {
      f(function(_, parent)
        return ("%s.begin(), %s.end()"):format(
          parent.snippet.env.POSTFIX_MATCH,
          parent.snippet.env.POSTFIX_MATCH
        )
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".mv",
    name = "move(expr)",
    dscr = "Wraps an expression with 'std::move' if it is available",
    nodes = {
      f(function(_, parent)
        return ("std::move(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".fwd",
    name = "forward(expr)",
    dscr = "Wraps an expression with 'std::forward' if it is available.",
    nodes = {
      f(function(_, parent)
        return ("std::forward<decltype(%s)>(%s)"):format(
          parent.snippet.env.POSTFIX_MATCH,
          parent.snippet.env.POSTFIX_MATCH
        )
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".val",
    name = "declval<expr>()",
    dscr = "Wraps an expression with 'std::declval' if it is available.",
    nodes = {
      f(function(_, parent)
        return ("std::declval<%s>()"):format(parent.snippet.env.POSTFIX_MATCH)
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".uu",
    name = "(void)expr",
    dscr = "Wraps an expression with '(void)expr' to silence unused variable warnings.",
    nodes = {
      f(function(_, parent)
        return ("(void)%s;"):format(parent.snippet.env.POSTFIX_MATCH)
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".dt",
    name = "decltype(expr)",
    dscr = "Wraps an expression with 'decltype' to get the type of an expression.",
    nodes = {
      f(function(_, parent)
        return ("decltype(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".for",
    name = "for (expr)",
    dscr = "Wraps an expression with a range-based 'for' loop.",
    nodes = fmta(
      [[
      for (<typ> <item> : <expr>) {
        <body>
      }
      ]],
      {
        body = i(0),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
        typ = c(1, {
          t("const auto&"),
          t("auto&&"),
        }),
        item = i(2, "item"),
      }
    ),
  },

  ts_postfix_any_expr {
    ".fori",
    name = "for (int i = 0; i < expr; i++)",
    dscr = "Wraps an expression with a 'for' loop.",
    nodes = fmta(
      [[
      for (decltype(<expr>) i = 0; i << <expr>; i++) {
        <body>
      }
      ]],
      {
        body = i(0),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
      }
    ),
  },

  ts_postfix_any_expr {
    ".if",
    name = "if (expr)",
    dscr = "Wraps an expression with an 'if' condition.",
    nodes = fmta(
      [[
      if (<expr>) {
        <body>
      }
      ]],
      {
        body = i(0),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
      }
    ),
  },

  ts_postfix_any_expr {
    ".else",
    name = "if (!expr)",
    dscr = "Negates an expression and wraps it with 'if'.",
    nodes = fmta(
      [[
      if (!<expr>) {
        <body>
      }
      ]],
      {
        body = i(0),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
      }
    ),
  },

  ts_postfix_any_expr {
    ".sc",
    name = "static_cast<>(expr)",
    dscr = "Wraps an expression with 'static_cast'.",
    nodes = fmt(
      [[
      static_cast<{body}>({expr}){end}
      ]],
      {
        body = i(1),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
        ["end"] = i(0),
      }
    ),
  },

  ts_postfix_any_expr {
    ".cast",
    name = "xxx_cast<>(expr)",
    dscr = "Wraps an expression with a cast expression.",
    nodes = fmt(
      [[
      {cast}<{body}>({expr}){end}
      ]],
      {
        cast = c(1, {
          t("static_cast"),
          t("reinterpret_cast"),
          t("dynamic_cast"),
          t("const_cast"),
        }),
        body = i(2),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
        ["end"] = i(0),
      }
    ),
  },
}
