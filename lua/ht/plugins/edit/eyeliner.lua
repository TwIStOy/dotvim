return {
  -- motion in line with f/F
  Use {
    "jinh0/eyeliner.nvim",
    lazy = {
      cmd = { "EyelinerEnable", "EyelinerDisable", "EyelinerToggle" },
      keys = {
        { "f", nil, mode = { "n" } },
        { "F", nil, mode = { "n" } },
        { "t", nil, mode = { "n" } },
        { "T", nil, mode = { "n" } },
      },
      opts = { highlight_on_key = true, dim = true },
      config = true,
    },
    functions = {
      {
        filter = {
          filter = require("ht.core.const").not_in_common_excluded,
        },
        values = {
          FuncSpec("Enable Eyeliner", "EyelinerEnable"),
          FuncSpec("Disable Eyeliner", "EyelinerDisable"),
          FuncSpec("Toggle Eyeliner", "EyelinerToggle"),
        },
      },
    },
  },
}
