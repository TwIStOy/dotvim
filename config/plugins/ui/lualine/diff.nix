{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_diff = {
      "diff",
      color = {
        bg = _G.dotvim_resolve_bg("CursorLine"),
        fg = _G.dotvim_resolve_fg("IncSearch"),
        gui = "bold",
      },
      padding = { left = 1 },
      separator = { left = "", right = "" },
      symbols = {
        added = "",
        modified = "",
        removed = "",
      },
    }
  '';
}
