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
    require("dotvim.pkgs.theme.plugins.flexoki"),
    require("dotvim.pkgs.theme.plugins.tokyo-night"),
    require("dotvim.pkgs.theme.plugins.evergarden"),
    require("dotvim.pkgs.theme.plugins.citruszest"),
    require("dotvim.pkgs.theme.plugins.onenord"),
    require("dotvim.pkgs.theme.plugins.ares"),
    require("dotvim.pkgs.theme.plugins.yorumi"),
  },
  setup = function()
    if not vim.g.vscode then
      vim.o.background = "dark"
      vim.cmd("colorscheme catppuccin")
    end
  end,
}
