---@type dotvim.core.package.PackageOption
return {
  name = "dotvim.packages.theme",
  plugins = {
    require("dotvim.packages.theme.plugins.catppuccin"),
  },
  setup = function()
    vim.cmd("colorscheme catppuccino")
  end,
}
