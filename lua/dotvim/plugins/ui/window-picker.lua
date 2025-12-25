---@type LazyPluginSpec
return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  opts = {
    hint = "floating-big-letter",
  },
  config = function(_, opts)
    require("window-picker").setup(opts)
  end,
}
