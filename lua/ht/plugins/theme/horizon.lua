return {
  "akinsho/horizon.nvim",
  enabled = false,
  opts = {
    plugins = {
      cmp = true,
      indent_blankline = true,
      nvim_tree = true,
      telescope = true,
      which_key = true,
      barbar = false,
      notify = true,
      symbols_outline = false,
      neo_tree = false,
      gitsigns = true,
      crates = true,
      hop = true,
      navic = true,
      quickscope = false,
    },
  },
  config = function(_, opts)
    require("horizon").setup(opts)

    vim.o.background = "dark"
    vim.cmd.colorscheme("horizon")
  end,
}
