---@type dotvim.core.plugin.PluginOption
return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = true,
  opts = {
    variant = "auto",
    dark_variant = "main",
    extend_background_behind_borders = false,
    styles = {
      bold = true,
      italic = false,
      transparency = false,
    },
    highlight_groups = {
      TelescopeBorder = { fg = "overlay", bg = "overlay" },
      TelescopeNormal = { fg = "subtle", bg = "overlay" },
      TelescopeSelection = { fg = "text", bg = "highlight_med" },
      TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
      TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

      TelescopeTitle = { fg = "base", bg = "love" },
      TelescopePromptTitle = { fg = "base", bg = "pine" },
      TelescopePreviewTitle = { fg = "base", bg = "iris" },

      TelescopePromptNormal = { fg = "text", bg = "surface" },
      TelescopePromptBorder = { fg = "surface", bg = "surface" },
      ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
      ["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      },
      ["@variable.builtin"] = { italic = true },
    },
  },
}
