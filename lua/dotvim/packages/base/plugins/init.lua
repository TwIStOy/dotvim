---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "osyo-manga/vim-jplus",
    event = "BufReadPost",
    keys = { { "J", "<Plug>(jplus)", mode = { "n", "v" }, noremap = false } },
    gui = "all",
  },
  require("dotvim.packages.base.plugins.mason"),
  require("dotvim.packages.base.plugins.toggleterm"),
}
