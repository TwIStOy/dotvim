return {
  -- scroll
  {
    "dstein64/nvim-scrollview",
    lazy = true,
    enabled = false,
    event = { "BufReadPost" },
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "folke/tokyonight.nvim",
    },
    opts = {},
    config = function()
      require("scrollview").setup {
        excluded_filetypes = {
          "prompt",
          "TelescopePrompt",
          "noice",
          "toggleterm",
          "nuipopup",
          "NvimTree",
          "rightclickpopup",
        },
        current_only = true,
        winblend = 75,
        base = "right",
        column = 2,
        signs_on_startup = { "all" },
        diagnostics_severities = { vim.diagnostic.severity.WARN },
      }
    end,
  },
}
