---@type dotvim.core.plugin.PluginOption
return {
  "scottmckendry/cyberdream.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("cyberdream").setup {
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
      terminal_colors = true,
      theme = {
        ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = {
          underline = true,
        },
        ["@variable.builtin"] = { italic = true },
      },
    }
  end,
}
