return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "catppuccin",
    },
    config = function()
      require("lspsaga").setup {
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = { quit = { "q", "<Esc>" }, exec = "<CR>" },
        },
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = false },
        ui = {
          -- kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        },
      }
    end,
  },
}
