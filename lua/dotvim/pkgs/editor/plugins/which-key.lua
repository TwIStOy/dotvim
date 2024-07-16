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
        ---@type wk.IconRule[]
        rules = {
          {
            plugin = "neogen",
            icon = " ",
            color = "blue",
          },
          { plugin = "neotest", icon = "󰙨 ", color = "red" },

          { pattern = "delete", icon = " ", color = "blue" },
          { pattern = "xray", icon = " ", color = "purple" },
          { pattern = "bookmark", icon = "󰸕 ", color = "yellow" },
          { pattern = "clear", icon = " ", color = "red" },
          { pattern = "list", icon = " ", color = "grey" },
          { pattern = "hydra", icon = " ", color = "orange" },
          { pattern = "HYDRA", icon = " ", color = "orange" },
          { pattern = "save", icon = " ", color = "green" },
          { pattern = "outline", icon = " ", color = "purple" },
          { pattern = "trouble", icon = " ", color = "yellow" },
          { pattern = "vcs", icon = "󰊢 ", color = "red" },
          { pattern = "conflict", icon = " ", color = "cyan" },
          { pattern = "yazi", icon = " ", color = "yellow" },
          { pattern = "format", icon = " ", color = "cyan" },
        },
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>b", group = "bookmarks" },
          { "<leader>c", group = "clear" },
          { "<leader>f", group = "file" },
          {
            "<leader>h",
            group = "local",
            icon = {
              icon = " ",
              color = "blue",
            },
          },
          { "<leader>l", group = "list" },
          {
            "<leader>n",
            group = "no",
            icon = { icon = " ", color = "red" },
          },
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
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
