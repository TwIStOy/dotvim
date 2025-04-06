---@module 'dotvim.fs'
local M = {}

---@param bufnr number
---@return string?
function M.direnv_root(bufnr)
  local root = vim.fs.root(bufnr, ".envrc")
  return root
end

return M
