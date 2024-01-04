return {
  "EdenEast/nightfox.nvim",
  enabled = true,
  lazy = false,
  opts = {
    terminal_colors = true,
    groups = {
      all = {
        ["@lsp.typemod.variable.mutable.rust"] = { style = "underline" },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = { style = "underline" },
      },
    },
  },
  config = function(_, opts)
    require("nightfox").setup(opts)
    vim.cmd("colorscheme nightfox")
  end,
}
