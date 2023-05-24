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
  -- copyright
  snippet {
    "cr",
    name = "Copyright",
    dscr = "Create copyright header",
    mode = "bwA",
    cond = cond.at_first_line,
    nodes = fmt(
      [[
    // Copyright (c) 2020 - present, {}
    //
    {}
    ]],
      {
        f(function()
          local path = vim.fn.expand("%:p")
          if path:find("agora") then
            return "Agora.io, Inc."
          else
            return "Hawtian Wang (twistoy.wang@gmail.com)"
          end
        end),
        i(0),
      }
    ),
  },

  -- progma once
  ls.s({
    trig = "once",
    name = "progma once",
    dscr = "#Progma once with comments",
    wordTrig = true,
    snippetType = "autosnippet",
  }, {
    t { "#pragma once  // NOLINT(build/header_guard)", "" },
  }, cond.at_line_begin("once") + cpp_util.all_lines_before_are_all_comments),

  -- include short cuts
  ls.s({
    trig = '#"',
    name = 'include ""',
    dscr = "#include with quotes",
    snippetType = "autosnippet",
  }, {
    t('#include "'),
    i(1, "header"),
    t('"'),
  }, cond.at_line_begin('#"')),
  ls.s({
    trig = "#<",
    name = "include <>",
    dscr = "#include with angle brackets",
    snippetType = "autosnippet",
  }, {
    t("#include <"),
    i(1, "header"),
    t(">"),
  }, cond.at_line_begin("#<")),
}
