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
local s = ls.snippet

local simple_comment = function(prefix)
  return snippet {
    prefix,
    name = prefix:upper() .. " comment",
    dscr = prefix:upper() .. " comment",
    mode = "wb",
    nodes = {
      t("// " .. prefix:upper() .. "(hawtian): "),
      i(0),
    },
  }
end

return {
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
          local parts = vim.split(snip.captures[1], "::", {
            plain = true,
            trimempty = true,
          })
          local names = {}
          for _, part in ipairs(parts) do
            local nest_parts = vim.split(part, ".", {
              plain = true,
              trimempty = true,
            })
            vim.list_extend(names, nest_parts)
          end
          return table.concat(names, "::")
        end),
      }
    ),
  },

  quick_expand("da", "decltype(auto) "),
  quick_expand("ca&", "const auto& "),
  quick_expand("a&&", "auto&& "),

  -- common comments
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
