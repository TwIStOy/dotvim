---@class dotvim.extra
local M = {}

---@type dora.lib
local lib = require("dora.lib")

---@async
---@param cmd string[]
---@param opts? vim.SystemOpts
---@return vim.SystemCompleted
function M.system(cmd, opts)
  return lib.async.wrap(vim.system)(cmd, opts)
end

---@type dotvim.extra.obsidian
M.obsidian = require("dotvim.extra.obsidian")

return M
