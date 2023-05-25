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
          local path = vim.fn.expand("%:p"):lower()
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
  snippet {
    "once",
    name = "progma once",
    dscr = "#Progma once with comments",
    mode = "bwA",
    cond = cpp_util.all_lines_before_are_all_comments,
    nodes = {
      t { "#pragma once  // NOLINT(build/header_guard)", "" },
    },
  },

  -- include short cuts
  snippet {
    '#"',
    name = 'include ""',
    dscr = "#include with quotes",
    mode = "bA",
    nodes = {
      t('#include "'),
      i(1, "header"),
      t('"'),
    },
  },
  snippet {
    "#<",
    name = "include <>",
    dscr = "#include with <>",
    mode = "bA",
    nodes = {
      t("#include <"),
      i(1, "header"),
      t(">"),
    },
  },

  -- compiler macros
  snippet {
    "#clang>",
    name = "Clang version greater",
    dscr = "Checks for clang version greater than the specified version",
    mode = "b",
    nodes = fmt(
      [[
      #if defined(__clang__) && ((__clang_major__ > {Major}) || ((__clang_major__ == {Major_v}) && (__clang_minor__ >= {Minor})))
      {body}
      #endif
      ]],
      {
        Major = i(1, "Major"),
        Major_v = rep(1),
        Minor = i(2, "Minor"),
        body = i(0),
      }
    ),
  },
  snippet {
    "#clang<",
    name = "Clang version greater",
    dscr = "Checks for clang version less than the specified version",
    mode = "b",
    nodes = fmt(
      [[
      #if defined(__clang__) && ((__clang_major__ < {Major}) || ((__clang_major__ == {Major_v}) && (__clang_minor__ <= {Minor})))
      {body}
      #endif
      ]],
      {
        Major = i(1, "Major"),
        Major_v = rep(1),
        Minor = i(2, "Minor"),
        body = i(0),
      }
    ),
  },
  snippet {
    "#gcc>",
    name = "Gcc version greater",
    dscr = "Checks for gcc version greater than the specified version",
    mode = "b",
    nodes = fmt(
      [[
      #if defined(__GNUC__) && ((__GNUC__ > {Major}) || ((__GNUC__ == {Major_v}) && (__GNUC_MINOR__ >= {Minor})))
      {body}
      #endif
      ]],
      {
        Major = i(1, "Major"),
        Major_v = rep(1),
        Minor = i(2, "Minor"),
        body = i(0),
      }
    ),
  },
  snippet {
    "#gcc<",
    name = "Gcc version less",
    dscr = "Checks for gcc version less than the specified version",
    mode = "b",
    nodes = fmt(
      [[
      #if defined(__GNUC__) && ((__GNUC__ < {Major}) || ((__GNUC__ == {Major_v}) && (__GNUC_MINOR__ <= {Minor})))
      {body}
      #endif
      ]],
      {
        Major = i(1, "Major"),
        Major_v = rep(1),
        Minor = i(2, "Minor"),
        body = i(0),
      }
    ),
  },

  -- common stl types
  snippet {
    "#cpp20",
    name = "C++20 macro tester",
    dscr = "Test if C++20 is supported",
    mode = "bA",
    nodes = {
      t { "#if __cplusplus >= 202002L", "" },
      i(0),
      t { "", "#endif" },
    },
  },
}
