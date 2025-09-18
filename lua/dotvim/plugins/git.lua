---@type LazyPluginSpec[]
return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    opts = {
      default_mappings = true,
      disable_diagnostics = false,
    },
  },
}
