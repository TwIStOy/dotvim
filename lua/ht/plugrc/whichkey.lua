return {
  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      key_labels = { ["<space>"] = "SPC", ["<cr>"] = "RET", ["<tab>"] = "TAB" },
      layout = { align = 'center' },
      ignore_missing = false,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:",
                 "^ " },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },

        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },

        ["<leader>b"] = { name = "+build" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>l"] = { name = "+list" },
        ["<leader>n"] = { name = "+no" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>v"] = { name = "+vcs" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>x"] = { name = "+xray" },
      }
    end,
  },
}
