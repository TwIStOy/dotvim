local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "phaazon/hop.nvim",
  cmd = {
    "HopWord",
    "HopPattern",
    "HopChar1",
    "HopChar2",
    "HopLine",
    "HopLineStart",
  },
  opts = { keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 },
  actions = lib.plugin.action.make_options {
    from = "hop.nvim",
    category = "Hop",
    ---@type dora.lib.ActionOptions[]
    actions = {
      {
        id = "hop.word",
        title = "Hop to word",
        callback = "HopWord",
      },
      {
        id = "hop.pattern",
        title = "Hop to pattern",
        callback = "HopPattern",
      },
      {
        id = "hop.char1",
        title = "Hop to char1",
        callback = "HopChar1",
      },
      {
        id = "hop.char2",
        title = "Hop to char2",
        callback = "HopChar2",
      },
      {
        id = "hop.line",
        title = "Hop to line",
        callback = "HopLine",
        keys = { ",l", desc = "jump-to-line" },
      },
      {
        id = "hop.line-start",
        title = "Hop to line start",
        callback = "HopLineStart",
      },
    },
  },
}
