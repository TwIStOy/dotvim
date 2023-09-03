local M = {}

---Check if the given path exists and is a file.
---@param path string Input path.
---@return boolean
function M.is_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

---Check if the given path exists and is a directory.
---@param path string Input path.
---@return boolean
function M.is_directory(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory" or false
end

---Write data to a file.
---@param path string Input path.
---@param data string|table Data to write. Use `vim.inspect` for tables.
---@param mode "w"|"a"|nil Write or append mode.
function M.write_all(path, data, mode)
  local uv = vim.uv
  data = type(data) == "string" and data or vim.inspect(data)
  uv.fs_open(path, mode, 438, function(open_err, fd)
    assert(not open_err, open_err)
    uv.fs_write(fd, data, -1, function(write_err)
      assert(not write_err, write_err)
      uv.fs_close(fd, function(close_err)
        assert(not close_err, close_err)
      end)
    end)
  end)
end

---Returns the topmost parent directory which match the conditions or nil if
---not found.
---@param p any
---@param matcher fun(path: string): boolean
---@return string|nil
function M.topmost_parent(p, matcher)
  local Path = require("plenary.path")

  ---@type Path
  local current = Path.new(p)
  if not current:is_dir() then
    current = current:parent()
  end

  ---@param path Path
  ---@return Path|nil
  local function try_path(path)
    if tostring(path) == tostring(path:parent()) then
      return nil
    end
    local res
    if matcher(tostring(path)) then
      res = path
    end
    return try_path(path:parent()) or res
  end

  local res = try_path(current)
  if res ~= nil then
    return tostring(res)
  end
  return nil
end

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

---Returns the path of the current file's git repo.
---@return string?
function M.git_repo_path()
  local Path = require("plenary.path")
  local Str = require("ht.utils.str")
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
  return Str.trim(res.stdout)
end

return M
