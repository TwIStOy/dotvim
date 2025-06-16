local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Diagnostics with comprehensive icons
local function create_component()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic", "nvim_lsp", "coc" },
    symbols = {
      error = icon.get("DiagnosticError", 1),
      warn = icon.get("DiagnosticWarn", 1),
      info = icon.get("DiagnosticInfo", 1),
      hint = icon.get("DiagnosticHint", 1),
      ok = icon.get("LSPLoaded", 1),
    },
    diagnostics_color = {
      error = { fg = utils.resolve_fg("DiagnosticError") },
      warn = { fg = utils.resolve_fg("DiagnosticWarn") },
      info = { fg = utils.resolve_fg("DiagnosticInfo") },
      hint = { fg = utils.resolve_fg("DiagnosticHint") },
    },
    colored = true,
    update_in_insert = false,
    always_visible = false,
    color = {
      bg = utils.resolve_bg("CursorLine"),
      fg = utils.resolve_fg("Normal"),
      gui = "bold",
    },
    separator = { left = "", right = "" },
    padding = 1,
  }
end

return create_component
