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
      vim.o.background = "light"
      vim.cmd("colorscheme rose-pine")
    end
  end,
}
