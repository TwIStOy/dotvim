---@type dotvim.core.plugin.PluginOption
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
  end,
  opts = {
    signs = {
      left = "",
      right = "",
      diag = "●",
      arrow = "    ",
      up_arrow = "    ",
      vertical = " │",
      vertical_end = " └",
    },
    hi = {
      error = "DiagnosticError",
      warn = "DiagnosticWarn",
      info = "DiagnosticInfo",
      hint = "DiagnosticHint",
      arrow = "NonText",
      background = "CursorLine",
      mixing_color = "None",
    },
    blend = {
      factor = 0.27,
    },
    options = {
      softwrap = 15,
      overflow = "wrap",
      break_line = {
        enabled = false,
        after = 30,
      },
    },
  },
}
