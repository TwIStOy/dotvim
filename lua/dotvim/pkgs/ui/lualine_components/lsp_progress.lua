---@type dotvim.utils
local Utils = require("dotvim.utils")

local current_message

local function update_message()
  local ok, lsp_progress = pcall(require, "lsp-progress")
  if not ok then
    return ""
  end
  current_message = lsp_progress.progress {
    max_size = 80,
    format = function(messages)
      if #messages > 0 then
        return table.concat(messages, " ")
      end
      return ""
    end,
  }
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LspProgressStatusUpdated",
  callback = update_message,
})

return {
  function()
    if current_message then
      return current_message
    else
      return ""
    end
  end,
  separator = { left = "", right = "" },
  color = {
    bg = Utils.vim.resolve_bg("CursorLine"),
    fg = Utils.vim.resolve_fg("Comment"),
    gui = "bold",
  },
}
