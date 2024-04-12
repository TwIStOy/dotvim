---@type dotvim.core.package.PackageOption
return {
  name = "theme",
  plugins = {
    require("dotvim.pkgs.theme.plugins.catppuccin"),
    require("dotvim.pkgs.theme.plugins.rose-pine"),
    require("dotvim.pkgs.theme.plugins.cyberdream"),
  },
  setup = function()
    if not vim.g.vscode then
      vim.cmd("colorscheme catppuccin")
      vim.o.background = "light"
    end
  end,
}
