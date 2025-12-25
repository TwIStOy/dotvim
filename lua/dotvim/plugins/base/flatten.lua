---@type LazyPluginSpec
return {
  "willothy/flatten.nvim",
  enabled = not vim.g.vscode,
  lazy = false,
  priority = 1001,
  opts = {},
}
