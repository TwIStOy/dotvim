return {
  "s1n7ax/nvim-window-picker",
  lazy = true,
  config = true,
  opts = {
    filter_rules = {
      bo = {
        filetype = { "NvimTree", "neo-tree", "notify" },
        buftype = { "terminal" },
      },
    },
  },
}
