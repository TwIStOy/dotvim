return {
  -- motion
  Use {
    "phaazon/hop.nvim",
    lazy = {
      cmd = {
        "HopWord",
        "HopPattern",
        "HopChar1",
        "HopChar2",
        "HopLine",
        "HopLineStart",
      },
      opts = { keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 },
    },
    functions = {
      FuncSpec(
        "Jump to line",
        "HopLine",
        { keys = ",l", desc = "jump-to-line" }
      ),
    },
  },
}
