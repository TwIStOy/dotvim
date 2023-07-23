local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local i = ht_snippet.insert_node
local ls = require("luasnip")
local t = ls.text_node
local f = ls.function_node
local quick_expand = ht_snippet.quick_expand
local fmt = require("luasnip.extras.fmt").fmt
local ts_postfix = require("ht.snippets.cpp.ts_postfix")

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

return {
  -- simple int types
  simple_int_type(8),
  simple_int_type(16),
  simple_int_type(32),
  simple_int_type(64),
  simple_int_type(8, true),
  simple_int_type(16, true),
  simple_int_type(32, true),
  simple_int_type(64, true),

  -- stl types, only full specialization types and these types can be used in CTAD
  quick_expand("vec", "std::vector", "bw"),
  quick_expand("vecs", "std::vector<std::string>", "bw"),
  quick_expand("opt", "std::optional", "bw"),

  -- make pointers
  snippet {
    "msp",
    name = "make shared pointer",
    dscr = "make shared pointer",
    mode = "bw",
    nodes = fmt("auto {name} = std::make_shared<{type}>({args});", {
      name = i(1, "name"),
      type = i(2, "type"),
      args = i(3, "args"),
    }),
  },
  snippet {
    "mup",
    name = "make unique pointer",
    dscr = "make unique pointer",
    mode = "bw",
    nodes = fmt("auto {name} = std::make_unique<{type}>({args});", {
      name = i(1, "name"),
      type = i(2, "type"),
      args = i(3, "args"),
    }),
  },
}
