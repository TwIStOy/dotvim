local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Git branch with custom styling
local function create_component()
  return {
    "branch",
    icon = icon.icon("GitBranch"),
    color = {
      bg = utils.resolve_fg("Type"),
      fg = utils.resolve_fg("IncSearch"),
      gui = "bold",
    },
    separator = { left = "", right = "" },
  }
end

return create_component
