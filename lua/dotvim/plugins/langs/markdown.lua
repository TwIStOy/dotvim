---@type LazyPluginSpec[]
return {
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    ft = { "markdown" },
    opts = {},
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
