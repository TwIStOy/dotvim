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
      "jsonclass",
      name = "@JsonSerializable() class",
      dscr = "@JsonSerializable() class",
      mode = "bw",
      nodes = fmt(
        [[
        @JsonSerializable()
        class 6name9 {
          factory 6display_name9.fromJson(Map<String, dynamic> json) =>
              _$6display_name9FromJson(json);
          Map<String, dynamic> toJson() => _$6display_name9ToJson(this);
        }
        ]],
        {
          name = i(1, "ClassName"),
          display_name = rep(1),
        },
        {
          delimiters = "69",
        }
      ),
    },
  }
end
