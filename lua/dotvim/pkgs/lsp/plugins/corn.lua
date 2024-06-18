---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "RaafatTurki/corn.nvim",
  cmd = "Corn",
  enabled = false,
  opts = {
    auto_cmds = false,
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
      -- TODO(hawtian): improve line-breaks by Knuth-Plass algorithm
      local max_width = vim.api.nvim_win_get_width(0) / 2
      item.message = vim.fn.split(item.message, "\n")
      local lines = {}
      for _, line in ipairs(item.message) do
        if #line > max_width then
          local line_parts = vim.fn.split(line, " ")
          local current_line = ""
          for _, part in ipairs(line_parts) do
            if #current_line + #part + 1 > max_width then
              table.insert(lines, current_line)
              current_line = ""
            end
            current_line = current_line .. " " .. part
          end
          table.insert(lines, current_line)
        else
          table.insert(lines, line)
        end
      end
      item.message = table.concat(lines, "\n")
      return item
    end,
  },
}
