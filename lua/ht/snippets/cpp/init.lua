return function()
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

  local function import_snippets(module)
    local m = require(module)
    if m ~= nil then
      return m
    end
    return {}
  end

  local res = {}

  res = vim.list_extend(res, import_snippets("ht.snippets.cpp.snippets.func"))
  res = vim.list_extend(res, import_snippets("ht.snippets.cpp.snippets.type"))
  res = vim.list_extend(res, import_snippets("ht.snippets.cpp.snippets.macro"))
  res =
    vim.list_extend(res, import_snippets("ht.snippets.cpp.snippets.postfix"))

  local extra_snippets = {
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
  }

  res = vim.list_extend(res, extra_snippets)
  return res
end
