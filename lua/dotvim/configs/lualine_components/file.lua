local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Current file with icon
local function create_component()
  local current_file = icon.get("DefaultFile", 1) .. "Empty"

  vim.api.nvim_create_autocmd({
    "BufEnter",
    "DirChanged",
  }, {
    callback = function()
      local file_icon = icon.icon("DefaultFile") .. " "
      local currentFile = vim.fn.expand("%")
      local filename
      if currentFile == "" then
        filename = "Empty"
      else
        filename = vim.fn.fnamemodify(currentFile, ":.")
        local deviconsPresent, devicons = pcall(require, "nvim-web-devicons")
        if deviconsPresent then
          local ftIcon = devicons.get_icon(filename)
          if ftIcon ~= nil then
            file_icon = ftIcon .. " "
          end
          if vim.fn.expand("%:e") == "md" then
            file_icon = file_icon .. icon.icon("WordFile") .. " "
          end
        end
      end
      current_file = file_icon .. filename
    end,
  })

  return {
    function()
      return current_file
    end,
    color = {
      bg = utils.resolve_bg("CursorLine"),
      fg = utils.resolve_fg("Normal"),
    },
    separator = { left = "", right = "" },
    padding = { left = 1 },
  }
end

return create_component
