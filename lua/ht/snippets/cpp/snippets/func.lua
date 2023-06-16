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

local function in_argument()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local curnode = vim.treesitter.get_node {
    bufnr = buf,
    pos = {
      row - 1,
      col - 1,
    },
  }
  return curnode and curnode:type() == "argument_list"
end

return {
  snippet {
    "fn",
    name = "define a simple function",
    dscr = "define a simple function",
    mode = "bw",
    nodes = fmta(
      [[
      <storage_specifier> auto <name>(<args>) <specifier> ->> <ret> {
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

  snippet {
    "getter",
    name = "Getter function",
    dscr = "Declare an inline getter function",
    mode = "bw",
    nodes = fmta(
      [[
      inline decltype(auto) Get<name>() const noexcept { return (<member>); }
      ]],
      {
        member = i(1, "member"),
        name = f(function(args)
          return (args[1][1])
            :gsub("_(%l)", function(s)
              return s:upper()
            end)
            :gsub("^%l", string.upper)
            :gsub("_$", "")
        end, { 1 }),
      }
    ),
  },

  snippet {
    "|trans",
    name = "std/ranges-v3 transform",
    dscr = "std/ranges-v3 transform function",
    mode = "b",
    nodes = fmta(
      [[
      | <ns>::views::transform([&](auto&& value) {
        <body>
      })
      ]],
      {
        ns = c(1, {
          t("std"),
          t("ranges"),
        }, { desc = "namespace" }),
        body = i(0),
      }
    ),
  },

  snippet {
    "|filter",
    name = "std/ranges-v3 filter",
    dscr = "std/ranges-v3 filter function",
    mode = "b",
    nodes = fmta(
      [[
      | <ns>::views::filter([&](auto&& value) ->> bool {
        <body>
      })
      ]],
      {
        ns = c(1, {
          t("std"),
          t("ranges"),
        }, { desc = "namespace" }),
        body = i(0),
      }
    ),
  },

  snippet {
    "|vec",
    name = "ranges-v3 to vector",
    dscr = "ranges-v3 to vector",
    mode = "b",
    nodes = {
      t("| ranges::to_vector"),
    },
  },

  snippet {
    ",d",
    name = "Doxygen comment",
    dscr = "Doxygen template to document a var/func/etc",
    mode = "bwA",
    nodes = fmta(
      [[
      /*!
       * @brief <brief>
       *
       * <body>
       */
      ]],
      {
        brief = i(1, "This is something undocumented."),
        body = i(2, "Nothing to add here..."),
      }
    ),
  },

  snippet {
    "\\",
    name = "lambda function in arguments",
    dscr = "lambda function in arguments",
    mode = "wA",
    cond = require("ht.snippets.conditions.cond").make_condition(
      in_argument,
      in_argument
    ),
    nodes = fmta(
      [[
      [this, &](<>) <> {
        <>
      }
      ]],
      {
        i(2),
        c(1, {
          t("mutable"),
          t(""),
        }),
        i(0),
      }
    ),
  },
}
