---@type dotvim.utils
local Utils = require("dotvim.utils")

local current_file = "󰈚 Empty"
vim.api.nvim_create_autocmd({
  "BufEnter",
  "DirChanged",
}, {
  callback = function()
    local icon = "󰈚 "
    local currentFile = vim.fn.expand("%")
    local filename
    if currentFile == "" then
      filename = "Empty "
    else
      filename = vim.fn.fnamemodify(currentFile, ":.")
      local deviconsPresent, devicons = pcall(require, "nvim-web-devicons")
      if deviconsPresent then
        local ftIcon = devicons.get_icon(filename)
        if ftIcon ~= nil then
          icon = ftIcon .. " "
        end
        if vim.fn.expand("%:e") == "md" then
          icon = icon .. " "
        end
      end
    end
    current_file = icon .. filename
  end,
})

return {
  function()
    return current_file
  end,
  color = {
    bg = Utils.vim.resolve_bg("CursorLine"),
    fg = Utils.vim.resolve_fg("Normal"),
  },
  separator = { left = "", right = "" },
  padding = { left = 1 },
}
