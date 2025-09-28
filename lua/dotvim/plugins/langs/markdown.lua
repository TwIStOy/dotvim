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
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Projects/Nexus/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Projects/Nexus/*.md"
    },
    opts = {
      workspaces = {
        {
          name = "Nexus",
          path = "~/Projects/Nexus",
        },
      },
    },
  },
}
