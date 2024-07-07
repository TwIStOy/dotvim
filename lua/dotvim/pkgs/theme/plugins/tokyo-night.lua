---@type dotvim.core.plugin.PluginOption
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      functions = {},
      variables = {},
    },
    transparent = false,
    day_brightness = 0.3,
    sidebars = { "qf", "vista_kind", "terminal", "packer", "help" },
    on_highlights = function(hl, c)
      hl["@lsp.typemod.variable.mutable.rust"] = {
        underline = true,
      }
      hl["@lsp.typemod.selfKeyword.mutable.rust"] = {
        underline = true,
      }

      -- borderless telescope
      local prompt = "#2d3149"
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = prompt,
      }
      hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePromptTitle = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
    end,
  },
}
