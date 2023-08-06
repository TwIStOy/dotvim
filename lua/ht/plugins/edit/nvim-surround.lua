return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
}
