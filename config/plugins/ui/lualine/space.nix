{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_space = {
      function() return " " end,
      color = {
        bg = _G.dotvim_resolve_bg("Normal"),
        fg = _G.dotvim_resolve_bg("Normal"),
      },
      separator = { left = "", right = "" },
      padding = 0,
      draw_empty = true,
    }
  '';
}
