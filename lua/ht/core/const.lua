local M = {}

local os = vim.loop.os_uname().sysname

M.os = {
  name = os,
  is_macos = os == "Darwin",
  is_linux = os == "Linux",
  is_windows = os == "Windows",
}

M.common_excluded_ft = {
  NvimTree = true,
  alpha = true,
  nuipopup = true,
  rightclickpopup = true,
}

---@param buffer VimBuffer
function M.not_in_common_excluded(buffer)
  return M.common_excluded_ft[buffer.filetype] == nil
end

M.lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

M.mason_path = vim.fn.stdpath("data") .. "/mason"

M.mason_bin = M.mason_path .. "/bin"

return M
