local M = {}

---@type string
local os = vim.uv.os_uname().sysname

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

---@type string
M.lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@type string
M.mason_path = vim.fn.stdpath("data") .. "/mason"

---@type string
M.mason_bin = M.mason_path .. "/bin"

---@type boolean
M.is_gui = (function()
  if vim.g["neovide"] then
    return true
  end
  if vim.g["fvim_loaded"] then
    return true
  end
  return false
end)()

return M
