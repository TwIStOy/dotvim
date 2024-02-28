---@class dora.lib.fs
local M = {}

---Returns the path of the current file's git repo.
---@return string?
function M.git_repo_path()
  local Path = require("plenary.path")
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir

  if current_file == "" then
    current_dir = Path.new(vim.fn.getcwd())
  else
    local current = Path.new(current_file)
    current_dir = current:parent()
  end

  local p = vim.system({
    "git",
    "rev-parse",
    "--show-toplevel",
  }, {
    cwd = tostring(current_dir),
  })

  local res = p:wait()
  if res.code ~= 0 then
    return nil
  end

  local stdout = res.stdout

  return stdout:match("^()%s*$") and "" or stdout:match("^%s*(.*%S)")
end

return M
