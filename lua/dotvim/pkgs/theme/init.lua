---@type dotvim.core.package.PackageOption
return {
  name = "theme",
  plugins = {
    require("dotvim.pkgs.theme.plugins.catppuccin"),
  },
  setup = function()
    vim.cmd("colorscheme catppuccino")
  end,
}
