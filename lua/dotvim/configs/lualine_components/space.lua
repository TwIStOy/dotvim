local utils = require("dotvim.configs.lualine_components.utils")

-- Component: Spacer
local function create_component()
  return {
    function()
      return " "
    end,
    color = { bg = utils.resolve_bg("Normal"), fg = utils.resolve_bg("Normal") },
    separator = { left = "", right = "" },
    padding = 0,
    draw_empty = true,
  }
end

return create_component
