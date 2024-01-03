local ls = require("luasnip")
local f = ls.function_node
local tsp = require("luasnip.extras.treesitter_postfix")
local su = require("ht.snippets.utils")

local wrapped_types = {
  "struct_expression",
  "call_expression",
  "identifier",
}

return {
  tsp.treesitter_postfix({
    trig = ".rc",
    name = "Rc::new(?)",
    dscr = "Wrap expression with Rc::new()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".rc"
    ),
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
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".arc"
    ),
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
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".box"
    ),
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
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".mu"
    ),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Mutex::new(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".ok",
    name = "Ok(?)",
    dscr = "Wrap expression with Ok(?)",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".ok"
    ),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Ok(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".err",
    name = "Err(?)",
    dscr = "Wrap expression with Err()",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = tsp.builtin.tsnode_matcher.find_topmost_types(
      wrapped_types,
      ".err"
    ),
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Err(%s)")
    end, {}),
  }),

  tsp.treesitter_postfix({
    trig = ".some",
    name = "(.some) Some(?)",
    dscr = "Wrap expression with Some(?)",
    wordTrig = false,
    reparseBuffer = nil,
    matchTSNode = {
      query = [[
        [
          (struct_expression)
          (call_expression)
          (identifier)
          (field_expression)
        ] @prefix
      ]],
      query_lang = "rust",
    },
  }, {
    f(function(_, parent)
      return su.replace_all(parent.snippet.env.LS_TSMATCH, "Some(%s)")
    end, {}),
  }),
}
