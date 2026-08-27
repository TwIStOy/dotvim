{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_diff = {
      "diff",
      color = function()
        return {
          bg = _G.dotvim_resolve_bg("CursorLine"),
          fg = _G.dotvim_resolve_fg("IncSearch"),
          gui = "bold",
        }
      end,
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
