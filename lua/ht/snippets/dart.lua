return function()
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local quick_expand = hs.quick_expand
  local i = hs.insert_node
  local c = hs.choice_node

  local ls = require("luasnip")
  local t = ls.text_node
  local f = ls.function_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep

  return {
    snippet {
      "fn",
      name = "Define a function",
      dscr = "Define a function",
      mode = "bw",
      nodes = fmta(
        [[
        <ret> <name>(<args>) {
          <body>
        }
        ]],
        {
          body = i(0),
          name = i(1, "FuncName", { desc = "function name" }),
          args = i(2, "", { desc = "arguments" }),
          ret = i(3, "void", { desc = "return type" }),
        }
      ),
    },

    quick_expand("fs", "final String ", "bw"),

    snippet {
      "afn",
      name = "Define an async function",
      dscr = "Define an async function",
      mode = "bw",
      nodes = fmta(
        [[
        <ret> <name>(<args>) async {
          <body>
        }
        ]],
        {
          body = i(0),
          name = i(1, "FuncName", { desc = "function name" }),
          args = i(2, "", { desc = "arguments" }),
          ret = i(3, "void", { desc = "return type" }),
        }
      ),
    },

    snippet {
      "sfw",
      name = "StatefulWidget class",
      dscr = "create a StatefulWidget class",
      mode = "bw",
      nodes = fmta(
        [[
        class <name> extends StatefulWidget {
          const <rep_name>({super.key});

          @override
          State<<<rep_name>>> createState() =>> _<rep_name>State();
        }

        class _<rep_name>State extends State<<<rep_name>>> {
          @override
          void initState() {
            super.initState();
            // TODO(hawtian): Implement initState
          }

          @override
          Widget build(BuildContext context) {
            // TODO(hawtian): Implement build
            throw UnimplementedError();
          }
        }
        ]],
        {
          name = i(1, "ClassName"),
          rep_name = rep(1),
        }
      ),
    },

    snippet {
      "slw",
      name = "StatelessWidget class",
      dscr = "create a StatelessWidget class",
      mode = "bw",
      nodes = fmta(
        [[
        class <name> extends StatelessWidget {
          <rep_name>({super.key});

          @override
          Widget build(BuildContext context) {
            // TODO(hawtian): Implement build
            throw UnimplementedError();
          }
        }
        ]],
        {
          name = i(1, "ClassName"),
          rep_name = rep(1),
        }
      ),
    },

    snippet {
      "@jc",
      name = "@JsonSerializable() class",
      dscr = "@JsonSerializable() class",
      mode = "bw",
      nodes = fmta(
        [[
        @JsonSerializable()
        class <name> {
          factory <rep_name>.fromJson(Map<<String, dynamic>> json) =>>
              _$<rep_name>FromJson(json);
          Map<<String, dynamic>> toJson() =>> _$<rep_name>ToJson(this);
        }
        ]],
        {
          name = i(1, "ClassName"),
          rep_name = rep(1),
        }
      ),
    },

    snippet {
      "jc!",
      name = "$_xxxFromJson/ToJson() methods",
      mode = "bwA",
      nodes = fmt(
        [[
        factory {name}.fromJson(Map<String, dynamic> json) =>
            _${rep_name}FromJson(json);
        Map<String, dynamic> toJson() => _${rep_name}ToJson(this);
        ]],
        {
          name = i(1, "ClassName"),
          rep_name = rep(1),
        }
      ),
    }
  }
end
