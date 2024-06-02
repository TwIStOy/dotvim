---@type dotvim.core.plugin.PluginOption
return {
  "comfysage/evergarden",
  priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  opts = {
    transparent_background = false,
    contrast_dark = "medium", -- 'hard'|'medium'|'soft'
    overrides = {
      ["@lsp.typemod.variable.mutable.rust"] = {
        underline = true,
      },
      ["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      },
    },
  },
}
