local ht_snippet = require("ht.snippets.snippet")
local ls = require("luasnip")
local i = ht_snippet.insert_node
local c = ht_snippet.choice_node
local t = ls.text_node
local f = ls.function_node
local ts_postfix = require("ht.snippets.cpp.ts_postfix")
local ts_postfix_any_expr = ts_postfix.cpp_ts_postfix_any_expr
local ts_postfix_ident_only = ts_postfix.cpp_ts_postfix_ident_only
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt
local su = require("ht.snippets.utils")
local tsp = require("luasnip.extras.treesitter_postfix")

return {
  ts_postfix_ident_only {
    ".cs",
    name = "cs",
    dscr = "Toggle case style",
    nodes = {
      f(function(_, parent)
        -- switch name style from snake to pascal or vice versa
        -- name must be a oneline identifier
        local name = parent.snippet.env.POSTFIX_MATCH[1]
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

  tsp.treesitter_postfix({
    trig = ".be",
    name = "begin..end",
    dscr = "Completes a variable with both begin() and end().",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = {
      query_lang = "cpp",
      match_captures = {
        "any_expr",
      },
    },
  }, {
    f(function(_, parent)
      return su.replace_all(
        parent.snippet.env.LS_TSMATCH,
        "%s.begin(), %s.end()"
      )
    end, {}),
  }),

  ts_postfix_any_expr {
    ".mv",
    name = "move(expr)",
    dscr = "Wraps an expression with 'std::move' if it is available",
    nodes = {
      f(function(_, parent)
        return su.replace_all(parent.snippet.env.POSTFIX_MATCH, "std::move(%s)")
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".fwd",
    name = "forward(expr)",
    dscr = "Wraps an expression with 'std::forward' if it is available.",
    nodes = {
      f(function(_, parent)
        return su.replace_all(
          parent.snippet.env.POSTFIX_MATCH,
          "std::forward<decltype(%s)>(%s)"
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
        return su.replace_all(
          parent.snippet.env.POSTFIX_MATCH,
          "std::declval<%s>()"
        )
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".uu",
    name = "(void)expr",
    dscr = "Wraps an expression with '(void)expr' to silence unused variable warnings.",
    nodes = {
      f(function(_, parent)
        return su.replace_all(parent.snippet.env.POSTFIX_MATCH, "(void)%s;")
      end, {}),
    },
  },

  ts_postfix_any_expr {
    ".dt",
    name = "decltype(expr)",
    dscr = "Wraps an expression with 'decltype' to get the type of an expression.",
    nodes = {
      f(function(_, parent)
        return su.replace_all(parent.snippet.env.POSTFIX_MATCH, "decltype(%s)")
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

  function()
    local fori_types = vim.deepcopy(ts_postfix.any_expr_types)
    fori_types[#fori_types + 1] = "number_literal"
    return ts_postfix.ts_postfix_maker(fori_types) {
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
    }
  end,

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
        }, {
          desc = "Type conversion casts",
        }),
        body = i(2),
        expr = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
        ["end"] = i(0),
      }
    ),
  },

  ts_postfix_ident_only {
    ".fd",
    name = "if (..find)",
    dscr = "Find a member exists in given indent.",
    nodes = fmta(
      [[
      if (auto it = <ident>.find(<key>); it <equal> <ident>.end()) {
        <body>
      }
      ]],
      {
        ident = f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH
        end, {}),
        key = i(1, "key"),
        equal = c(2, {
          t("=="),
          t("!="),
        }, {
          desc = "Equals, Not Equals",
        }),
        body = i(0),
      }
    ),
  },
}
