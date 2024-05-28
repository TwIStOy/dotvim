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
  },
  setup = function()
    if not vim.g.vscode then
      vim.o.background = "light"
      vim.cmd("colorscheme catppuccin")
      -- vim.cmd("colorscheme flexoki-" .. vim.o.background)
      -- vim.cmd("colorscheme tokyonight")
    end
  end,
}
