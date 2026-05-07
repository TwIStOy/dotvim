{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_branch = {
      "branch",
      icon = "",
      color = {
        bg = _G.dotvim_resolve_fg("Type"),
        fg = _G.dotvim_resolve_fg("IncSearch"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
    }
  '';
}
