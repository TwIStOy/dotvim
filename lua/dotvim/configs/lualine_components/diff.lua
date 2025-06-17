local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Git diff with custom icons
local function create_component()
  return {
    "diff",
    color = {
      bg = utils.resolve_bg("CursorLine"),
      fg = utils.resolve_fg("IncSearch"),
      gui = "bold",
    },
    padding = { left = 1 },
    separator = { left = "", right = "" },
    symbols = {
      added = icon.get("GitAdd", 1),
      modified = icon.get("GitChange", 1),
      removed = icon.get("GitDelete", 1),
    },
  }
end

return create_component
