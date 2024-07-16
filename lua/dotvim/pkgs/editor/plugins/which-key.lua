---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      layout = { align = "center" },
      show_help = true,
      icons = {
        breadcrumb = "»",
        separator = "󰜴",
        group = "+",
      },
    },
    config = function(_, opts)
      vim.defer_fn(function()
        local wk = require("which-key")
        wk.setup(opts)
        wk.add {
          {
            mode = { "n", "v" },
            { "<leader>b", group = "bookmarks" },
            { "<leader>f", group = "file" },
            { "<leader>l", group = "list" },
            { "<leader>n", group = "no" },
            { "<leader>p", group = "preview" },
            { "<leader>r", group = "remote" },
            { "<leader>s", group = "search" },
            { "<leader>t", group = "test/toggle" },
            { "<leader>v", group = "vcs" },
            { "<leader>w", group = "window" },
            { "<leader>x", group = "xray" },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
          },
        }
      end, 100)
    end,
  },
}
