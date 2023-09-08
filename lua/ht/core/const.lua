local M = {}

local os_uname = vim.uv.os_uname()

---@type string
local os = os_uname.sysname
local release = os_uname.release

M.os = {
  name = os,
  is_macos = os == "Darwin",
  is_linux = os == "Linux",
  is_windows = os == "Windows",
  in_orb = release:find("orb") ~= nil,
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

M.in_vscode = (function()
  if vim.g.vscode then
    return true
  end
  return false
end)()

return M
