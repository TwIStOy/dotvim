---@type LazyPluginSpec
return {
  "TwIStOy/luasnip-snippets",
  lazy = true,
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    user = {
      name = "Hawtian Wang",
    },
    snippet = {
      lua = {
        vim_snippet = true,
      },
      rust = {
        rstest_support = true,
      },
    },
  },
}
