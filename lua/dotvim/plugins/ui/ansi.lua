---@type LazyPluginSpec
return {
  "0xferrous/ansi.nvim",
  cmd = { "AnsiEnable", "AnsiDisable", "AnsiToggle" },
  lazy = false,
  opts = {
    auto_enable = true,
    filetypes = { "log" },
    theme = "terminal",
  },
}
