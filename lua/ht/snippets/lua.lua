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
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local i = hs.insert_node
  local c = hs.choice_node

  local ls = require("luasnip")
  local t = ls.text_node
  local f = ls.function_node
  local sn = ls.snippet_node
  local d = ls.dynamic_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local postfix = require("luasnip.extras.postfix").postfix
  local l = extras.lambda
  local tsp = require("luasnip.extras.treesitter_postfix")

  return {
    snippet {
      "@if",
      mode = "bwA",
      nodes = d(1, function(_, parent)
        local env = parent.env

        local nodes = {
          t("if "),
          i(1, "condition"),
          t { " then", "" },
        }
        for _, ele in ipairs(env.LS_SELECT_RAW) do
          table.insert(nodes, t { "  " .. ele, "" })
        end
        table.insert(nodes, t { "end", "" })

        return sn(nil, nodes)
      end, {}),
    },

    snippet {
      "for!",
      mode = "bwhA",
      nodes = fmta(
        [[
        for i, v in <pairs>(<value>) do
          <body>
        end
        ]],
        {
          value = i(1, "value"),
          pairs = c(2, {
            t("pairs"),
            t("ipairs"),
          }),
          body = i(0, "body"),
        }
      ),
    },

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
          c(1, {
            t("local function"),
            t("function"),
          }, {
            desc = "local/global",
          }),
          i(2),
          i(3),
          i(0),
        }
      ),
    },

    snippet {
      "([%w_]+)%+%+",
      name = "foo++",
      dscr = "post increment",
      mode = "wr",
      hidden = true,
      nodes = fmt("{} = {} + 1", { l(l.CAPTURE1, {}), l(l.CAPTURE1, {}) }),
      cond = {
        show_condition = function()
          return false
        end,
      },
    },

    snippet {
      "req",
      name = "require(...)",
      dscr = "Require statement",
      mode = "wb",
      nodes = fmt([[local {} = require("{}")]], {
        ls.d(2, last_lua_module_section, { 1 }),
        i(1, "module"),
      }),
    },
  }
end
