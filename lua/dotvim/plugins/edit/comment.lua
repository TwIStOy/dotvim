---@type LazyPluginSpec
return {
  "numToStr/Comment.nvim",
  enabled = not vim.g.vscode,
  keys = {
    { "gcc", desc = "toggle-line-comment" },
    { "gcc", mode = "x", desc = "toggle-line-comment" },
    { "gbc", desc = "toggle-block-comment" },
    { "gbc", mode = "x", desc = "toggle-block-comment" },
  },
  opts = {
    toggler = { line = "gcc", block = "gbc" },
    opleader = { line = "gcc", block = "gbc" },
    mappings = { basic = true, extra = false },
  },
}
