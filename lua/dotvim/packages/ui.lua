---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages.ui",
  deps = {
    "dora.packages.ui",
  },
  plugins = {
    {
      "colorful-winsep.nvim",
      enabled = function()
        return not vim.g.neovide
      end,
    },
  },
}
