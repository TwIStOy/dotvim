---@type dora.lib.PluginOptions
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    key_labels = { ["<space>"] = "SPC", ["<cr>"] = "RET", ["<tab>"] = "TAB" },
    layout = { align = "center" },
    ignore_missing = false,
    hidden = {
      "<silent>",
      "<cmd>",
      "<Cmd>",
      "<CR>",
      "call",
      "lua",
      "^:",
      "^ ",
    },
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
      wk.register {
        mode = { "n", "v" },
        g = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+bookmarks" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>l"] = { name = "+list" },
        ["<leader>n"] = { name = "+no" },
        ["<leader>p"] = { name = "+preview" },
        ["<leader>r"] = { name = "+remote" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>v"] = { name = "+vcs" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>x"] = { name = "+xray" },
      }
    end, 100)
  end,
}
