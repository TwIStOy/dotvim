---@class dotvim.utils.fs
local M = {}

---@param file string filename
---@return string?
function M.read_file(file)
  local fd = io.open(file, "r")
  if fd == nil then
    return nil
  end
  ---@type string
  local data = fd:read("*a")
  fd:close()
  return data
end

---@param file string filename
---@param callback fun(data: string)
function M.read_file_then(file, callback)
  local data = M.read_file(file)
  if data == nil then
    return
  end
  callback(data)
end

---@param file string filename
---@param contents string
function M.write_file(file, contents)
  local fd = assert(io.open(file, "w+"))
  fd:write(contents)
  fd:close()
end

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

  ---@type string
  local stdout = res.stdout

  return stdout:match("^()%s*$") and "" or stdout:match("^%s*(.*%S)")
end

return M
