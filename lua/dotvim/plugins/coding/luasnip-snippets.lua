---@type LazyPluginSpec
return {
  "TwIStOy/luasnip-snippets",
  event = { "InsertEnter" },
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
      cpp = {
        quick_type = {
          extra_trig = {
            { trig = "m", params = 2, template = "std::unordered_map<%s, %s>" },
          },
          qt = true,
          cpplint = false,
        },
      },
    },
  },
}
