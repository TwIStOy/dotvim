---@class dora.config.nixpkgs
local M = {}

---@type table<string, string>
M.nixpkgs = {}

---@param name string
---@return string?
function M.resolve_pkg(name)
  return M.nixpkgs[name]
end

---@param opts? table<string, string>
function M.setup(opts)
  M.nixpkgs = opts or {}
end

return M
