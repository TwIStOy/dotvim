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

return M
