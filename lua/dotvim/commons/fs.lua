---@module 'dotvim.commons.fs'
local M = {}

--- Basenames (lowercase) whose contents must never be sent to an AI
--- assistant. Matched exactly by `is_sensitive_file`.
local SENSITIVE_FILENAMES = {
  [".envrc"] = true,
  ["secrets.yaml"] = true,
  ["secrets.yml"] = true,
  ["secrets.json"] = true,
  ["secrets.jsonc"] = true,
}

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

---Returns true if `path` points at a sensitive file whose contents must
---never be sent to an AI assistant (Copilot, etc.). Matched by basename,
---case-insensitive:
--- * exact: `.envrc`, `secrets.{yaml,yml,json,jsonc}`
--- * `.env` and its dotfile variants: `.env`, `.env.local`, `.env.production`, ...
--- * `*.env` suffix: `production.env`, `staging.env`, ...
---@param path string? full path or basename
---@return boolean sensitive
function M.is_sensitive_file(path)
  if type(path) ~= "string" or path == "" then
    return false
  end
  local name = vim.fn.fnamemodify(path, ":t"):lower()
  if name == "" then
    return false
  end
  if SENSITIVE_FILENAMES[name] then
    return true
  end
  if name == ".env" or vim.startswith(name, ".env.") then
    return true
  end
  return vim.endswith(name, ".env")
end

return M
