---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "RaafatTurki/corn.nvim",
  cmd = "Corn",
  opts = {
    blacklisted_modes = {
      "i",
    },
    icons = {
      error = Utils.icon.predefined_icon("DiagnosticError", 1),
      warn = Utils.icon.predefined_icon("DiagnosticWarn", 1),
      info = Utils.icon.predefined_icon("DiagnosticInfo", 1),
      hint = Utils.icon.predefined_icon("DiagnosticHint", 1),
    },
    item_preprocess_func = function(item)
      return item
    end,
  },
}
