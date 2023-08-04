local cpp_util = require("ht.snippets.cpp.util")
local ls = require("luasnip")
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local cond = require("ht.snippets.conditions.conditions")
local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local quick_expand = ht_snippet.quick_expand
local postfix = require("ht.snippets.cpp.postfix").postfix
local i = ht_snippet.insert_node
local c = ht_snippet.choice_node

local simple_comment = function(prefix)
  return snippet {
    prefix,
    name = prefix:upper() .. " comment",
    dscr = prefix:upper() .. " comment",
    mode = "wAb",
    nodes = {
      t("// " .. prefix:upper() .. "(hawtian): "),
      i(0),
    },
  }
end

return {
  snippet {
    "ns",
    name = "namespace",
    dscr = "namespace",
    mode = "bw",
    nodes = fmta(
      [[
      namespace <> {
      <>
      }  // namespace <>
      ]],
      {
        i(1, "namespace"),
        i(0),
        rep(1),
      }
    ),
  },

  snippet {
    "ns%s+(%S+)",
    name = "namespace",
    dscr = "namespace",
    mode = "br",
    nodes = fmta(
      [[
      namespace <name> {
      <body>
      }  // namespace <name>
      ]],
      {
        body = i(0),
        name = f(function(_, snip)
          return snip.captures[1]
        end),
      }
    ),
  },

  quick_expand("da", "decltype(auto) "),
  quick_expand("ca&", "const auto& "),
  quick_expand("a&&", "auto&& "),
  snippet {
    "ifc",
    name = "if constexpr",
    dscr = "if constexpr",
    mode = "bw",
    nodes = fmta(
      [[
      if constexpr (<>) {
        <>
      }
      ]],
      {
        i(1, "condition"),
        i(0),
      }
    ),
  },

  -- common comments
  simple_comment("todo"),
  simple_comment("fixme"),
  simple_comment("note"),
  simple_comment("unsafe"),

  -- access modifier
  snippet {
    "pri:",
    name = "private",
    dscr = "private",
    mode = "bwA",
    nodes = t { "private:", " " },
  },
  snippet {
    "pub:",
    name = "public",
    dscr = "public",
    mode = "bwA",
    nodes = t { "public:", " " },
  },
  snippet {
    "pro:",
    name = "protected",
    dscr = "protected",
    mode = "bwA",
    nodes = t { "protected:", " " },
  },

  -- loops
  snippet {
    "for:",
    mode = "bw",
    name = "range-base for",
    dscr = "range-base for",
    nodes = fmta(
      [[
        for (<value_type> value : <iterable>) {
          <body>
        }
        ]],
      {
        iterable = i(1, "iterable"),
        value_type = c(2, {
          t("auto&&"),
          t("const auto&"),
        }, { desc = "value_type" }),
        body = i(0),
      }
    ),
  },

  snippet {
    "for0",
    mode = "bw",
    name = "For loop from 0",
    dscr = "For loop from 0",
    nodes = fmta(
      [[
        for (auto i = 0u; i << <max_value>; i++) {
          <body>
        }
        ]],
      {
        max_value = i(1, "max_value"),
        body = i(0),
      }
    ),
  },

  snippet {
    "forr",
    mode = "bw",
    name = "Reverse for loop",
    dscr = "Reverse for loop",
    nodes = fmta(
      [[
        for (auto i = <max_value>; i >>= 0; i--) {
          <body>
        }
        ]],
      {
        max_value = i(1, "max_value"),
        body = i(0),
      }
    ),
  },
}
