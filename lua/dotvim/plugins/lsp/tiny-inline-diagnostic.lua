---@type LazyPluginSpec
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  priority = 1000,
  enabled = not vim.g.vscode,
  opts = {
    preset = "amongus",
    options = {
      show_source = {
        enabled = true,
        if_many = true,
      },
      overwrite_events = { "BufEnter", "LspAttach" },
      multilines = {
        enabled = true,
      },
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    vim.diagnostic.config { virtual_text = false }
  end,
}
