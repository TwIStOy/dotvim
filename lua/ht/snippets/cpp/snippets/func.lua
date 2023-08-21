local ls = require("luasnip")
local t = ls.text_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
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
    mode = "bw",
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
    mode = "w",
    nodes = fmta(
      [[
      | <ns>::views::transform([&](auto&& value) {
        <body>
      })
      ]],
      {
        ns = c(1, {
          t("ranges"),
          t("std"),
        }, { desc = "namespace" }),
        body = i(0),
      }
    ),
  },

  snippet {
    "|filter",
    name = "std/ranges-v3 filter",
    dscr = "std/ranges-v3 filter function",
    mode = "w",
    nodes = fmta(
      [[
      | <ns>::views::filter([&](auto&& value) ->> bool {
        <body>
      })
      ]],
      {
        ns = c(1, {
          t("ranges"),
          t("std"),
        }, { desc = "namespace" }),
        body = i(0),
      }
    ),
  },

  snippet {
    "|vec",
    name = "ranges-v3 to vector",
    dscr = "ranges-v3 to vector",
    mode = "w",
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
}
