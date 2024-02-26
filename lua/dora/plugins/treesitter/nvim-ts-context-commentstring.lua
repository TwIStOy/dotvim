---@type dora.lib.PluginOptions
return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    context_commentstring = {
      enable = true,
    },
  },
  config = function(_, opts)
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup(opts)
  end,
}
