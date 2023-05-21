local luasnip = require("luasnip")
local snip_cond = require("ht.snippets.conditions.conditions")

local function build_snippet(opts)
  local trig = opts[1]
  local name = opts.name or trig
  local dscr = opts.dscr or ("Snippet: " .. name)
  local mode = opts.mode or ""
  local wordTrig = mode:match("w") ~= nil
  local regTrig = mode:match("r") ~= nil
  local hidden = mode:match("h") ~= nil
  local snippetType = mode:match("A") ~= nil and "autosnippet" or "snippet"
  local nodes = opts.nodes
  local priority = opts.priority or nil

  local cond = opts.cond or nil

  if mode:match("b") ~= nil then
    local line_begin = snip_cond.at_line_begin(trig)
    cond = cond and (cond + line_begin) or line_begin
  end
  local trig_arg = {
    trig = trig,
    name = name,
    dscr = dscr,
    workTrig = wordTrig,
    regTrig = regTrig,
    hidden = hidden,
    priority = priority,
    snippetType = snippetType,
    condition = cond and cond.condition,
    show_condition = cond and cond.show_condition,
  }
  return luasnip.s(trig_arg, nodes)
end

local function build_simple_word_snippet(word, expanded)
  return build_snippet {
    word,
    name = expanded,
    dscr = expanded,
    mode = "w",
    nodes = luasnip.text_node(expanded),
  }
end

return {
  build_snippet = build_snippet,
  build_simple_word_snippet = build_simple_word_snippet,
}
