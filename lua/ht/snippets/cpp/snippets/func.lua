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

return {
  snippet {
    "fn",
    name = "define a simple function",
    dscr = "define a simple function",
    mode = "bw",
    nodes = fmta(
      [[
      <storage_specifier> <ret> <name>(<args>) <specifier> {
        <body>
      }
      ]],
      {
        body = i(0),
        storage_specifier = c(1, {
          t(""),
          t("static"),
          t("inline"),
        }, { desc = "storage specifier" }),
        ret = i(2, "auto", { desc = "return type" }),
        name = i(3, "name", { desc = "function name" }),
        args = i(4, "args", { desc = "function arguments" }),
        specifier = c(5, {
          t(""),
          t("const"),
          t("noexcept"),
          t("const noexcept"),
        }, { desc = "specifier" }),
      }
    ),
  },

  -- interfaces and virtual functions
  snippet {
    "itf",
    name = "Interface",
    dscr = "Declare interface",
    mode = "bw",
    nodes = fmta(
      [[
        struct <> {
          virtual ~<>() = default;

          <>
        };
        ]],
      {
        i(1, "Interface"),
        rep(1),
        i(0),
      }
    ),
  },

  snippet {
    "pvf",
    name = "Pure virtual function",
    dscr = "Declare pure virtual function",
    mode = "bwA",
    nodes = fmta("virtual <ret_t> <name>(<args>) <specifier> = 0;", {
      name = i(1, "func"),
      args = i(2, "args"),
      specifier = i(3, "const"),
      ret_t = i(4, "void"),
    }),
  },
}
