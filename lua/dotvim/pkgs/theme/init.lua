---@type dotvim.core.package.PackageOption
return {
  name = "theme",
  plugins = {
    require("dotvim.pkgs.theme.plugins.catppuccin"),
    require("dotvim.pkgs.theme.plugins.rose-pine"),
    require("dotvim.pkgs.theme.plugins.cyberdream"),
    require("dotvim.pkgs.theme.plugins.eldritch"),
    require("dotvim.pkgs.theme.plugins.rasmus"),
    require("dotvim.pkgs.theme.plugins.oldworld"),
  },
  setup = function()
    if not vim.g.vscode then
      vim.o.background = "dark"
      vim.cmd("colorscheme rose-pine")
    end
  end,
}
