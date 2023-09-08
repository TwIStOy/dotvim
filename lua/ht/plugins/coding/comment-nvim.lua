return {
  -- toggle comments
  {
    "numToStr/Comment.nvim",
    lazy = true,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    allow_in_vscode = true,
    keys = {
      { "gcc", nil, desc = "toggle-line-comment" },
      { "gcc", nil, mode = "x", desc = "toggle-line-comment" },
      { "gbc", nil, desc = "toggle-block-comment" },
      { "gbc", nil, mode = "x", desc = "toggle-block-comment" },
    },
    opts = {
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gcc",
        block = "gbc",
      },
      mappings = {
        basic = true,
        extra = false,
      },
      pre_hook = function()
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    },
    config = true,
  },
}
