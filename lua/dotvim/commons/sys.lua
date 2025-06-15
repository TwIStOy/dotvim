---@module "dotvim.commons.sys"

local M = {}

function M.is_darwin()
  return vim.uv.os_uname().sysname == "Darwin"
end

return M
