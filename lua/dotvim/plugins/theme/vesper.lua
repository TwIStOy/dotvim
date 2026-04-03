---@type LazyPluginSpec
return {
  "datsfilipe/vesper.nvim",
  enabled = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("vesper").setup(opts)

    if not vim.g.vscode and DOTVIM_theme == "vesper" then
      vim.o.background = "dark"
      vim.cmd("colorscheme vesper")
    end
  end,
}
