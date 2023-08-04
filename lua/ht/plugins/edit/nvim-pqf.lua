return {
  -- prettier quickfix/location list windows
  {
    "yorickpeterse/nvim-pqf",
    lazy = true,
    opts = {
      show_multiple_lines = true,
    },
    config = true,
    main = "pqf",
    keys = {
      {
        "tq",
        function()
          require("ht.core.window").toggle_quickfix()
        end,
      },
    },
  },
}
