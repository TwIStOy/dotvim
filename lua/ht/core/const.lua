local M = {}

local os = vim.loop.os_uname().sysname

M.os = {
  name = os,
  is_macos = os == "Darwin",
  is_linux = os == "Linux",
  is_windows = os == "Windows",
}

local common_excluded_ft = {
  NvimTree = true,
  alpha = true,
  nuipopup = true,
  rightclickpopup = true,
}
---@param buffer VimBuffer
function M.not_in_common_excluded(buffer)
  return common_excluded_ft[buffer.filetype] == nil
end

return M
