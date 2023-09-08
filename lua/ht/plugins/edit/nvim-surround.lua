return {
  {
    "kylechui/nvim-surround",
    version = "*",
    allow_in_vscode = true,
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
}
