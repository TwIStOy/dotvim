local M = {}

---Check if the given path exists and is a file.
---@param path string Input path.
---@return boolean
function M.is_file(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file" or false
end

---Check if the given path exists and is a directory.
---@param path string Input path.
---@return boolean
function M.is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

---Write data to a file.
---@param path string Input path.
---@param data string|table Data to write. Use `vim.inspect` for tables.
---@param mode "w"|"a"|nil Write or append mode.
function M.write_all(path, data, mode)
  local uv = vim.loop
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

return M
