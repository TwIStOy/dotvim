---@type LazyPluginSpec
return {
  "windwp/nvim-projectconfig",
  event = "VeryLazy",
  opts = {
    project_dir = "~/.config/nvim-projectconfig/",
    silent = false,
    project_config = {},
  },
}
