---@type dotvim.core.plugin.PluginOption
return {
  "dgox16/oldworld.nvim",
  lazy = true,
  opts = {
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      conditionals = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
  },
}
