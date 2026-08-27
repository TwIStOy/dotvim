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
        error = function()
          return { fg = _G.dotvim_resolve_fg("DiagnosticError") }
        end,
        warn = function()
          return { fg = _G.dotvim_resolve_fg("DiagnosticWarn") }
        end,
        info = function()
          return { fg = _G.dotvim_resolve_fg("DiagnosticInfo") }
        end,
        hint = function()
          return { fg = _G.dotvim_resolve_fg("DiagnosticHint") }
        end,
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      color = function()
        return {
          bg = _G.dotvim_resolve_bg("CursorLine"),
          fg = _G.dotvim_resolve_fg("Normal"),
          gui = "bold",
        }
      end,
      separator = { left = "", right = "" },
      padding = 1,
    }
  '';
}
