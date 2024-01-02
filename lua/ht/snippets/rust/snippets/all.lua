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
      "pfn",
      name = "pub fn ...",
      dscr = "pub fn ...",
      mode = "bwh",
      nodes = fmta(
        [[
        pub fn <name>() ->> <res> {
          <body>
        }
        ]],
        {
          name = i(1, "name"),
          res = i(2, "type"),
          body = i(0, "unimplemented!();"),
        }
      ),
    },

    snippet {
      "sds!",
      name = "(De)Serializable struct",
      mode = "bwAh",
      nodes = fmta(
        [[
        #[derive(Debug, Clone, Serialize, Deserialize)]
        pub struct <name> {
          <fields>
        }
        ]],
        {
          name = i(1, "name"),
          fields = i(0, "fields"),
        }
      ),
    },

    snippet {
      "it!",
      name = "impl ... for ...",
      mode = "bwAh",
      nodes = fmta(
        [[
        impl <trait> for <typ> {
          <body>
        }
        ]],
        {
          trait = i(1, "trait"),
          typ = i(2, "type"),
          body = i(0),
        }
      ),
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
