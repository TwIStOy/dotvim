---@type dotvim.core.plugin.PluginOption
return {
  "zootedb0t/citruszest.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    option = {
      transparent = false,
      bold = false,
      italic = false,
    },
    style = {
      ["@lsp.typemod.variable.mutable.rust"] = {
        underline = true,
      },
      ["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      },
      StatusLine = {
        bg = "None",
      },
    },
  },
}
