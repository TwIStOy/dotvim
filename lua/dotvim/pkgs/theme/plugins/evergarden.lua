---@type dotvim.core.plugin.PluginOption
return {
  "comfysage/evergarden",
  priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  opts = {
    transparent_background = false,
    contrast_dark = "medium", -- 'hard'|'medium'|'soft'
    overrides = {
      ["@lsp.typemod.variable.mutable.rust"] = {
        style = {
          "underline",
        },
      },
      ["@lsp.typemod.selfKeyword.mutable.rust"] = {
        style = {
          "underline",
        },
      },
      ["DiagnosticUnderlineError"] = {
        style = {
          "undercurl",
        },
      },
      ["DiagnosticUnderlineWarn"] = {
        style = {
          "undercurl",
        },
      },
      ["DiagnosticUnderlineInfo"] = {
        style = {
          "undercurl",
        },
      },
      ["DiagnosticUnderlineHint"] = {
        style = {
          "undercurl",
        },
      },
    },
    integrations = {
      blink_cmp = true,
      cmp = true,
      gitsigns = true,
      indent_blandline = { enable = false },
      which_key = true,
      telescope = true,
    },
  },
}
