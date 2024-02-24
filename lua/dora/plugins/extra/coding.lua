---@type dora.lib.PluginOptions[]
return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    event = "LspAttach",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      symbols = {
        separator = "󰮺",
      },
      theme = "catppuccin",
    },
    config = true,
  },
}
