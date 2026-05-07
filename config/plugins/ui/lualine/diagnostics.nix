{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic", "nvim_lsp", "coc" },
      symbols = {
        error = "",
        warn = "",
        info = "󰋼",
        hint = "󰌵",
        ok = "",
      },
      diagnostics_color = {
        error = { fg = _G.dotvim_resolve_fg("DiagnosticError") },
        warn = { fg = _G.dotvim_resolve_fg("DiagnosticWarn") },
        info = { fg = _G.dotvim_resolve_fg("DiagnosticInfo") },
        hint = { fg = _G.dotvim_resolve_fg("DiagnosticHint") },
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      color = {
        bg = _G.dotvim_resolve_bg("CursorLine"),
        fg = _G.dotvim_resolve_fg("Normal"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
      padding = 1,
    }
  '';
}
