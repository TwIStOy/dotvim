local ls = require("luasnip")
local f = ls.function_node
local tsp = require("luasnip.extras.treesitter_postfix")
local su = require("ht.snippets.utils")

return {
  tsp.treesitter_postfix({
    trig = ".rc",
    name = "Rc::new(?)",
    dscr = "Wrap expression with Rc::new()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types({
      "call_expression",
      "identifier",
    }, ".rc"),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Rc::new(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".arc",
    name = "Arc::new(?)",
    dscr = "Wrap expression with Arc::new()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types({
      "call_expression",
      "identifier",
    }, ".arc"),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Arc::new(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".box",
    name = "Box::new(?)",
    dscr = "Wrap expression with Box::new()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types({
      "call_expression",
      "identifier",
    }, ".box"),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Box::new(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".mu",
    name = "Mutex::new(?)",
    dscr = "Wrap expression with Mutex::new()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types({
      "call_expression",
      "identifier",
    }, ".mu"),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Mutex::new(%s)")
    end, {}),
  }),
}
