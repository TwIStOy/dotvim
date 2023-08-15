return {
  "ramojus/mellifluous.nvim",
  enabled = false,
  opts = {
    transparent_background = {
      enabled = false,
      floating_windows = false,
      telescope = false,
      file_tree = false,
      cursor_line = false,
      status_line = false,
    },
    plugins = {
      cmp = true,
      gitsigns = true,
      indent_blankline = false,
      nvim_tree = {
        enabled = true,
        show_root = true,
      },
      telescope = {
        enabled = true,
        nvchad_like = true,
      },
      startify = false,
    },
    color_set = "tender",
  },
  config = function(_, opts)
    require("mellifluous").setup(opts)
    vim.cmd("colorscheme mellifluous")
  end,
}
