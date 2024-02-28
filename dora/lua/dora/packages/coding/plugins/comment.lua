---@type dora.core.plugin.PluginOption
return {
  "numToStr/Comment.nvim",
  gui = "all",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  keys = {
    { "gcc", desc = "toggle-line-comment" },
    { "gcc", mode = "x", desc = "toggle-line-comment" },
    { "gbc", desc = "toggle-block-comment" },
    { "gbc", mode = "x", desc = "toggle-block-comment" },
  },
  opts = {
    toggler = { line = "gcc", block = "gbc" },
    opleader = { line = "gcc", block = "gbc" },
    mappings = { basic = true, extra = false },
    pre_hook = function()
      require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end,
  },
  config = true,
}
