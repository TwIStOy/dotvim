local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local i = ht_snippet.insert_node
local ls = require("luasnip")
local t = ls.text_node
local quick_expand = ht_snippet.quick_expand

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

  -- stl types
  quick_expand("vec", "std::vector"),
  quick_expand("vecs", "std::vector<std::string>"),
}
