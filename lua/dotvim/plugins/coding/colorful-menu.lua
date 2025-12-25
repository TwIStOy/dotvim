---@type LazyPluginSpec
return {
  "xzbdmw/colorful-menu.nvim",
  enabled = not vim.g.vscode,
  opts = {
    max_width = 65,
  },
}
