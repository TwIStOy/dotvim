return {
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = "80",
      disabled_filetypes = {
        "help",
        "NvimTree",
        "lazy",
        "mason",
        "help",
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
}