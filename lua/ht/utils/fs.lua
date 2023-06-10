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

---Returns the topmost parent directory which match the conditions or nil if not found.
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

return M
