return {
  -- disable color
  {
    "NvChad/nvim-colorizer.lua",
    ft = {
      "vim",
      "lua",
    },
    opts = {
      filetypes = {
        "vim",
        "lua",
      },
      user_default_options = {
        names = false,
      },
    },
    config = true,
  },
}
