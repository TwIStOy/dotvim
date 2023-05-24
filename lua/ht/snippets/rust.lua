return function()
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local quick_expand = hs.quick_expand
  local i = hs.insert_node

  local ls = require("luasnip")
  local c = ls.choice_node
  local t = ls.text_node
  local f = ls.function_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep

  return {
    snippet {
      "#cfg",
      name = "#[cfg(...)]",
      dscr = "#[cfg(...)]",
      mode = "bA",
      nodes = fmt("#[cfg({})]", {
        i(1, [[target_os = "linux"]], {
          desc = "cfg parameters",
        }),
      }),
    },
    snippet {
      "#der",
      name = "#[derive(...)]",
      dscr = "#[derive(...)]",
      mode = "bA",
      nodes = fmt("#[derive({})]", {
        i(1, [[Debug, Clone]], {
          desc = "derive types",
        }),
      }),
    },
    quick_expand("pc", "pub(crate) "),
    snippet {
      "mr",
      name = "match result {...}",
      dscr = "match Result<T, U>",
      mode = "bw",
      nodes = fmta(
        [[
        match <> {
          Ok(<>) =>> <>,
          Err(e) =>> {
            info!("error: {e}");
            return;
          }
        }
        ]],
        {
          i(1, "result"),
          rep(1),
          rep(1),
        }
      ),
    },
  }
end
