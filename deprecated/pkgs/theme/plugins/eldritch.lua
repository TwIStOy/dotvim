---@type dotvim.core.plugin.PluginOption
return {
  "eldritch-theme/eldritch.nvim",
  lazy = true,
  opts = {
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      conditionals = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer", "help" },
    lualine_bold = true,
    on_highlights = function(highlights, _)
      highlights["@lsp.typemod.variable.mutable.rust"] = {
        underline = true,
      }
      highlights["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      }
    end,
  },
}
