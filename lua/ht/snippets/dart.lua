local UtilsTbl = require("ht.utils.table")
--[[
  PointOfIntrest({
    required this.longitude,
    required this.latitude,
    this.description,
    this.poiId,
    this.duration,
  });
--]]
---@param class_name string
---@param decls ht.snippet.dart.Declaration[]
local function _build_constructor(class_name, decls)
  local lines = {}

  lines[#lines + 1] = ("%s({"):format(class_name)
  for _, decl in ipairs(decls) do
    lines[#lines + 1] = ("%sthis.%s,"):format(
      decl.nullable and "  " or "  required ",
      decl.identifier
    )
  end
  lines[#lines + 1] = "});"

  return lines
end

return function()
  local hs = require("ht.snippets.snippet")
  local snippet = hs.build_snippet
  local quick_expand = hs.quick_expand
  local i = hs.insert_node
  local c = hs.choice_node

  local ls = require("luasnip")
  local t = ls.text_node
  local f = ls.function_node
  local d = ls.dynamic_node
  local sn = ls.snippet_node
  local fmt = require("luasnip.extras.fmt").fmt
  local fmta = require("luasnip.extras.fmt").fmta
  local extras = require("luasnip.extras")
  local rep = extras.rep
  local su = require("ht.snippets.utils")

  local dart_ts = require("ht.snippets.dart._treesitter")

  return {
    snippet {
      "ctor!",
      name = "Constructor",
      mode = "bwA",
      resolveExpandParams = dart_ts.resolve_class_decls,
      nodes = {
        f(function(_, parent)
          local env = parent.snippet.env
          return _build_constructor(env.CLASS_NAME, env.CLASS_DECLS)
        end, {}),
      },
    },

    snippet {
      "js!",
      name = "$_xxxFromJson/ToJson() methods",
      mode = "bwA",
      resolveExpandParams = dart_ts.resolve_maybe_class_decl,
      nodes = d(1, function(_, parent)
        local env = parent.env
        if env.IN_CLASS then
          local lines = {
            "factory %s.fromJson(Map<String, dynamic> json) =>",
            "_$%sFromJson(json);",
            "Map<String, dynamic> toJson() => _$%sToJson(this);",
          }
          return sn(
            nil,
            t(UtilsTbl.list_map(lines, function(item)
              return item:gsub("%%s", env.CLASS_NAME)
            end))
          )
        else
          return sn(
            nil,
            fmta(
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
            )
          )
        end
      end),
    },

    snippet {
      "init!",
      name = "@override initState()",
      mode = "bwA",
      nodes = fmta(
        [[
        @override
        void initState() {
          super.initState();
          <body>
        }
        ]],
        {
          body = i(0),
        }
      ),
    },

    snippet {
      "dis!",
      name = "@override dispose()",
      mode = "bwA",
      nodes = fmta(
        [[
        @override
        void dispose() {
          <body>
          super.dispose();
        }
        ]],
        {
          body = i(0),
        }
      ),
    },

    quick_expand("fs", "final String ", "bw"),

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

    snippet {
      "wfn",
      name = "Define a function returns a Widget",
      dscr = "Define a function returns a Widget",
      mode = "bw",
      nodes = fmta(
        [[
        Widget _build<name>(BuildContext context) {
          <body>
        }
        ]],
        {
          body = i(0),
          name = i(1, "FuncName", { desc = "function name" }),
        }
      ),
    },

    snippet {
      "afn",
      name = "Define an async function",
      dscr = "Define an async function",
      mode = "bw",
      nodes = fmta(
        [[
        Future<<<ret>>> <name>(<args>) async {
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
      "sfw!",
      name = "StatefulWidget class",
      dscr = "create a StatefulWidget class",
      mode = "bwA",
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
      "slw!",
      name = "StatelessWidget class",
      dscr = "create a StatelessWidget class",
      mode = "bwA",
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
      "cls!",
      name = "class ...",
      mode = "bwA",
      nodes = fmta(
        [[
        class <name> {
          <body>
        }
        ]],
        {
          name = i(1, "ClassName"),
          body = i(0),
        }
      ),
    },
  }
end
