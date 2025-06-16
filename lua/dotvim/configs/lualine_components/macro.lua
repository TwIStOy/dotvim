local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Macro recording indicator
local function create_component()
  return {
    function()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return icon.get("MacroRecording", 1) .. "recording @" .. recording_register
      end
    end,
    color = {
      bg = utils.resolve_fg("Error"),
      fg = utils.resolve_bg("Normal"),
      gui = "bold",
    },
    separator = { left = "", right = "" },
  }
end

return create_component
