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

local function cpo_func_to_namespace(name)
  -- try to convert name from pascal case to snake case
  if name:match("^[A-Z]") then
    -- is pascal case now, change to snake case
    name = name:gsub("(%u+)(%u%l)", "%1_%2")
    name = name:gsub("([a-z0-9])([A-Z])", "%1_%2")
    name = name:gsub("-", "_")
    name = name:lower()
  end
  return ("%s_fn"):format(name)
end

return {
  snippet {
    "cpo",
    name = "cpo",
    dscr = "customization point object",
    mode = "bw",
    nodes = fmta(
      [[
      namespace <ns_name> {
      struct Fn {
        template<<typename T, bool _noexcept = true>>
        decltype(auto) operator()(T&& value) const noexcept(_noexcept) {
          <cursor>
        }
      };
      }  // namespace <ns_name>
      inline constexpr <ns_name>::Fn <name>{};
      ]],
      {
        name = i(1, "function name"),
        ns_name = f(function(args)
          return cpo_func_to_namespace(args[1][1])
        end, { 1 }),
        cursor = i(0),
      }
    ),
  },
}
