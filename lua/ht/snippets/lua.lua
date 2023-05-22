local function last_lua_module_section(args)
  local ls = require("luasnip")

  local text = args[1][1] or ""
  local split = vim.split(text, ".", { plain = true })

  local options = {}
  for len = 0, #split - 1 do
    local node =
      ls.t(table.concat(vim.list_slice(split, #split - len, #split), "_"))
    table.insert(options, node)
  end

  return ls.sn(nil, {
    ls.c(1, options),
  })
end

return function()
  local snippet = require("ht.snippets.snippet").build_snippet
  local word_expand = require("ht.snippets.snippet").build_simple_word_snippet
  local ls = require("luasnip")
  local c = ls.choice_node
  local t = ls.text_node
  local f = ls.function_node
  local i = ls.insert_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local postfix = require("luasnip.extras.postfix").postfix

  return {
    snippet {
      "fn",
      name = "create a function",
      dscr = "create a function",
      mode = "bw",
      nodes = fmt(
        [[
        {} {}({})
          {}
        end
        ]],
        {
          ls.c(1, {
            ls.t("function"),
            ls.t("local function"),
          }),
          ls.i(2),
          ls.i(3),
          ls.i(0),
        }
      ),
    },

    snippet {
      "req",
      name = "require(...)",
      dscr = "Require statement",
      mode = "wb",
      nodes = fmt([[local {} = require("{}")]], {
        ls.d(2, last_lua_module_section, { 1 }),
        ls.i(1),
      }),
    },
  }
end
