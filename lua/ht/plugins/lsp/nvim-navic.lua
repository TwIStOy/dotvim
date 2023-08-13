return {
  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    enabled = false,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
  },
}
