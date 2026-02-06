---@type LazyPluginSpec[]
return {
  {
    "oskarnurm/koda.nvim",
    enabled = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      auto = true,
      cache = true,
      styles = {
        functions = { bold = true },
        keywords = {},
        comments = {},
        strings = {},
        constants = {},
      },
    },
    config = function(_, opts)
      require("koda").setup(opts)

      if not vim.g.vscode and DOTVIM_theme == "koda" then
        vim.o.background = "dark"
        vim.cmd("colorscheme koda")
      end
    end,
  },
}
