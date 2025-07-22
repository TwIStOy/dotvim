---@type dotvim.core.plugin.PluginOption
return {
  "rmehri01/onenord.nvim",
  enabled = false,
  priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  opts = function()
    local colors = require("onenord.colors").load()
    return {
      theme = nil,
      fade_nc = false,
      styles = {
        comments = "NONE",
        strings = "NONE",
        keywords = "NONE",
        functions = "NONE",
        variables = "NONE",
        diagnostics = "undercurl",
      },
      borders = true,
      disable = {
        background = false,
        float_background = false,
        cursorline = false,
        eob_lines = true,
      },
      inverse = {
        match_paren = false,
      },
      custom_highlights = {},
      custom_colors = {
        ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = {
          style = { "underline" },
        },
        ["@variable.builtin"] = { style = { "italic" } },

        CmpItemMenu = { link = "@comment" },

        HydraRed = { fg = colors.red },
        HydraBlue = { fg = colors.blue },
        HydraAmaranth = { fg = colors.light_purple },
        HydraPink = { fg = colors.pink },
        HydraTeal = { fg = colors.green },
      },
    }
  end,
}
