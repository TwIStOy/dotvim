local M = {}

---@type dotvim.utils
local Utils = require("dotvim.utils")

M.vault_dir = function()
  return vim.F.if_nil(
    Utils.lazy.opts("obsidian.nvim").dir,
    vim.fn.expand("~/obsidian-data")
  )
end

return M
