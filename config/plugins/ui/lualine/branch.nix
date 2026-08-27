{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_branch = {
      "branch",
      icon = "",
      color = function()
        return {
          bg = _G.dotvim_resolve_fg("Type"),
          fg = _G.dotvim_resolve_fg("IncSearch"),
          gui = "bold",
        }
      end,
      separator = { left = "", right = "" },
    }
  '';
}
