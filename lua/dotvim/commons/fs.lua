---@module 'dotvim.commons.fs'
local M = {}

---Read a file and return its contents
---@param file string filename
---@return string?
function M.read_file(file)
  local fd = io.open(file, "r")
  if fd == nil then
    return nil
  end
  local data = fd:read("*a")
  fd:close()
  return data
end

---Write contents to a file
---@param file string filename
---@param contents string
function M.write_file(file, contents)
  local fd = assert(io.open(file, "w+"))
  fd:write(contents)
  fd:close()
end

---Check if a file exists
---@param file string filename
---@return boolean
function M.file_exists(file)
  local fd = io.open(file, "r")
  if fd then
    fd:close()
    return true
  end
  return false
end

---Read a file and call callback with its contents
---@param file string filename
---@param callback fun(data: string)
function M.read_file_then(file, callback)
  local data = M.read_file(file)
  if data ~= nil then
    callback(data)
  end
end

return M
