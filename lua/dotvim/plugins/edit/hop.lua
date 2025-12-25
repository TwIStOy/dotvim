---@type LazyPluginSpec
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
  keys = {
    {
      ",l",
      "<cmd>HopLine<cr>",
      desc = "jump-to-line",
    },
  },
}
