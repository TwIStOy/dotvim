return {
  {
    "simrat39/symbols-outline.nvim",
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    config = true,
    opts = {
      keymaps = {
        close = { "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "K",
        toggle_preview = "p",
        rename_symbol = "R",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
      },
    },
  },
}
