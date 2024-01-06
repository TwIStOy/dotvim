return {
  "AlexvZyl/nordic.nvim",
  lazy = false,
  enabled = false,
  priority = 1000,
  opts = {
    -- Enable bold keywords.
    bold_keywords = true,
    -- Enable italic comments.
    italic_comments = true,
    -- Enable general editor background transparency.
    transparent_bg = false,
    -- Enable brighter float border.
    bright_border = false,
    -- Reduce the overall amount of blue in the theme (diverges from base Nord).
    reduced_blue = true,
    -- Swap the dark background with the normal one.
    swap_backgrounds = false,
    cursorline = {
      -- Bold font in cursorline.
      bold = false,
      -- Bold cursorline number.
      bold_number = false,
      -- Avialable styles: 'dark', 'light'.
      theme = "dark",
      -- Blending the cursorline bg with the buffer bg.
      blend = 0.85,
    },
    telescope = {
      style = "flat",
    },
    override = {
      FoldColumn = { bg = "none" },
      ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
      ["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true },
    },
  },
  config = function(_, opts)
    require("nordic").setup(opts)
    require("nordic").load()
  end,
}
