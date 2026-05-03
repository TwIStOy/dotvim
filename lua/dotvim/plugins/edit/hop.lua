---@type LazyPluginSpec
return {
  "yehuohan/hop.nvim",
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
      "<cmd>HopLineStart<cr>",
      desc = "jump-to-line",
    },
  },
}
