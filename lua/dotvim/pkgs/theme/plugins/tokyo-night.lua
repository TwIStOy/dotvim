---@type dotvim.core.plugin.PluginOption
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      functions = {},
      variables = {},
    },
    day_brightness = 0.3,
    sidebars = { "qf", "vista_kind", "terminal", "packer", "help" },
    on_highlights = function(highlights, colors)
      highlights["@lsp.typemod.variable.mutable.rust"] = {
        underline = true,
      }
      highlights["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      }
    end,
  },
}
