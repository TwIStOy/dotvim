return function()
  local cpp_util = require("ht.snippets.cpp.util")
  local ls = require("luasnip")
  local c = ls.choice_node
  local t = ls.text_node
  local f = ls.function_node
  local i = ls.insert_node
  local postfix = require("luasnip.extras.postfix").postfix
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local cond = require("ht.snippets.conditions.conditions")
  local snippet = require("ht.snippets.snippet").build_snippet
  local word_expand = require("ht.snippets.snippet").build_simple_word_snippet

  local simple_comment = function(prefix)
    return snippet {
      prefix,
      name = prefix:upper() .. " comment",
      dscr = prefix:upper() .. " comment",
      mode = "wA",
      nodes = {
        t("// " .. prefix:upper() .. "(hawtian): "),
        i(0),
      },
    }
  end
  local simple_int_type = function(bit, unsigned)
    local prefix = unsigned and "u" or ""
    local trig = (unsigned and "u" or "i") .. bit
    return snippet {
      trig,
      name = trig,
      dscr = prefix .. "int" .. bit .. "_t",
      mode = "wA",
      nodes = t(prefix .. "int" .. bit .. "_t"),
    }
  end

  return {
    -- copyright
    ls.s({
      trig = "cr",
      name = "Copyright",
      dscr = "Create copyright header",
      wordTrig = true,
      snippetType = "autosnippet",
    }, {
      t("// Copyright (c) 2020 - present, "),
      f(function()
        local path = vim.fn.expand("%:p")
        if path:find("agora") then
          return "Agora.io, Inc."
        else
          return "Hawtian Wang (twistoy.wang@gmail.com)"
        end
      end),
      t { "", "//", "" },
    }, cond.at_first_line + cond.at_line_begin("cr")),

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

    snippet {
      "ns",
      name = "namespace",
      dscr = "namespace",
      mode = "b",
      nodes = {
        t("namespace "),
        i(1, "namespace"),
        t { " {", "" },
        i(0),
        t { "", "}  // namespace " },
        rep(1),
      },
    },

    word_expand("da", "decltype(auto) "),
    word_expand("ca&", "const auto& "),
    word_expand("a&&", "auto&& "),
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

    -- compiler macros
    snippet {
      "#clang>",
      name = "Clang version greater",
      dscr = "Checks for clang version greater than the specified version",
      mode = "b",
      nodes = fmt(
        "defined(__clang__) && ((__clang_major__ > {Major}) || ((__clang_major__ == {Major_v}) && (__clang_minor__ >= {Minor})))",
        {
          Major = i(1, "Major"),
          Major_v = rep(1),
          Minor = i(2, "Minor"),
        }
      ),
    },
    snippet {
      "#clang<",
      name = "Clang version greater",
      dscr = "Checks for clang version less than the specified version",
      mode = "b",
      nodes = fmt(
        "defined(__clang__) && ((__clang_major__ < {Major}) || ((__clang_major__ == {Major_v}) && (__clang_minor__ <= {Minor})))",
        {
          Major = i(1, "Major"),
          Major_v = rep(1),
          Minor = i(2, "Minor"),
        }
      ),
    },
    snippet {
      "#gcc>",
      name = "Gcc version greater",
      dscr = "Checks for gcc version greater than the specified version",
      mode = "b",
      nodes = fmt(
        "defined(__GNUC__) && ((__GNUC__ > {Major}) || ((__GNUC__ == {Major_v}) && (__GNUC_MINOR__ >= {Minor})))",
        {
          Major = i(1, "Major"),
          Major_v = rep(1),
          Minor = i(2, "Minor"),
        }
      ),
    },
    snippet {
      "#gcc<",
      name = "Gcc version less",
      dscr = "Checks for gcc version less than the specified version",
      mode = "b",
      nodes = fmt(
        "defined(__GNUC__) && ((__GNUC__ < {Major}) || ((__GNUC__ == {Major_v}) && (__GNUC_MINOR__ <= {Minor})))",
        {
          Major = i(1, "Major"),
          Major_v = rep(1),
          Minor = i(2, "Minor"),
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

    -- common comments
    simple_comment("todo"),
    simple_comment("fixme"),
    simple_comment("note"),

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

    -- simple int types
    simple_int_type(8),
    simple_int_type(16),
    simple_int_type(32),
    simple_int_type(64),
    simple_int_type(8, true),
    simple_int_type(16, true),
    simple_int_type(32, true),
    simple_int_type(64, true),

    -- postfixes
    postfix(".be", {
      f(function(_, parent)
        return ("std::begin(%s), std::end(%s)"):format(
          parent.snippet.env.POSTFIX_MATCH,
          parent.snippet.env.POSTFIX_MATCH
        )
      end, {}),
    }),
    postfix(".mv", {
      f(function(_, parent)
        return ("std::move(%s)"):format(parent.snippet.env.POSTFIX_MATCH)
      end, {}),
    }),
    postfix(".fwd", {
      f(function(_, parent)
        return ("std::forward<decltype(%s)>(%s)"):format(
          parent.snippet.env.POSTFIX_MATCH,
          parent.snippet.env.POSTFIX_MATCH
        )
      end, {}),
    }),
  }
end
