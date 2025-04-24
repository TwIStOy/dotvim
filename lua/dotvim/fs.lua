---@module 'dotvim.fs'
local M = {}

---@param bufnr number
---@return string?
function M.direnv_root(bufnr)
  local root = vim.fs.root(bufnr, ".envrc")
  return root
end

---Read the entire content of a file
---@param filepath string Path to the file
---@return string? File content, returns nil if file doesn't exist or reading fails
function M.read_file(filepath)
  -- Check if file exists
  local file = io.open(filepath, "r")
  if not file then
    return nil
  end
  
  -- Read the entire file content
  local content = file:read("*a")
  file:close()
  
  return content
end

return M
