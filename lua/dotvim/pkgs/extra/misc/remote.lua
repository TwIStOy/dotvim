---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.remote",
  deps = {
    "coding",
    "editor",
    "ui",
  },
  plugins = {
    {
      "amitds1997/remote-nvim.nvim",
      version = "*",
      dependencies = {
        "plenary.nvim",
        "nui.nvim",
        "telescope.nvim",
      },
      config = true,
      opts = {
      },
    },
  },
}
