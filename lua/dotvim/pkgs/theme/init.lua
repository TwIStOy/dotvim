---@type dotvim.core.package.PackageOption
return {
  name = "theme",
  plugins = {
    require("dotvim.pkgs.theme.plugins.catppuccin"),
  },
  setup = function()
    if not vim.g.vscode then
      vim.cmd("colorscheme catppuccin")
    end
  end,
}
