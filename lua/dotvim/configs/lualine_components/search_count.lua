local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Search count
local function create_component()
  return {
    function()
      if vim.v.hlsearch == 0 then
        return ""
      end
      local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
      if not ok or next(result) == nil then
        return ""
      end
      local denominator = math.min(result.total, result.maxcount)
      return icon.get("Search", 1) .. string.format("%d/%d", result.current, denominator)
    end,
    color = {
      bg = utils.resolve_fg("IncSearch"),
      fg = utils.resolve_bg("Normal"),
      gui = "bold",
    },
    separator = { left = "", right = "" },
  }
end

return create_component
