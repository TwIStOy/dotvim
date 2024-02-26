---@type dora.lib.PluginOptions
return {
  "windwp/nvim-ts-autotag",
  gui = "all",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup {
      autotag = {
        enable = true,
      },
    }
  end,
}
