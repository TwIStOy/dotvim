local M = {}

local os = vim.loop.os_uname().sysname

M.os = {
  name = os,
  is_macos = os == "Darwin",
  is_linux = os == "Linux",
  is_windows = os == "Windows",
}

return M
