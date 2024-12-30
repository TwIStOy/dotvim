---@type dotvim.utils
local Utils = require("dotvim.utils")

local current_cwd

local function refresh_current_cwd()
  local dir = vim.fn.getcwd()
  local home = os.getenv("HOME") --[[@as string]]
  local match = string.find(dir, home, 1, true)
  if match == 1 then
    dir = "~" .. string.sub(dir, #home + 1)
  end
  current_cwd = Utils.icon.predefined_icon("FolderOpen", 1) .. dir
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "DirChanged",
}, {
  callback = function()
    refresh_current_cwd()
  end,
})

return {
  function()
    if not current_cwd then
      refresh_current_cwd()
    end
    return current_cwd
  end,
  color = {
    bg = Utils.vim.resolve_fg("Macro"),
    fg = Utils.vim.resolve_fg("IncSearch"),
    gui = "bold",
  },
  separator = { left = "", right = "" },
}
