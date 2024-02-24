local M = {}

---Check if the current directory is in a git repo.
---@param buffer VimBuffer?
---@return boolean
function M.in_git_repo(buffer)
  local Path = require("plenary.path")
  local cwd = nil
  if buffer ~= nil and buffer.filename ~= nil and buffer.filename ~= "" then
    cwd = tostring(Path.new(buffer.filename):parent())
  end

  local p = vim.system({
    "git",
    "rev-parse",
    "--is-inside-work-tree",
  }, {
    cwd = cwd,
  })
  local res = p:wait()
  return res.code == 0
end

return M
