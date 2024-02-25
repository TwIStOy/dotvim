---@type dora.lib.PluginOptions
return {
  "junegunn/vim-easy-align",
  cmd = { "EasyAlign" },
  dependencies = {
    {
      "godlygeek/tabular",
      cmd = { "Tabularize" },
    },
  },
  keys = {
    { "<leader>ta", "<cmd>EasyAlign<CR>", desc = "easy-align" },
    { "<leader>ta", "<cmd>EasyAlign<CR>", mode = "x", desc = "easy-align" },
  },
  gui = "all",
}
