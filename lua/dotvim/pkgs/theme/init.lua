---@type dotvim.core.package.PackageOption
return {
  name = "theme",
  plugins = {
    require("dotvim.pkgs.theme.plugins.catppuccin"),
    require("dotvim.pkgs.theme.plugins.rose-pine"),
  },
  setup = function()
    if not vim.g.vscode then
      vim.cmd("colorscheme rose-pine")
    end
  end,
}
