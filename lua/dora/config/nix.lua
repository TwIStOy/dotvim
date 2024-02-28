---@class dora.config.nix
local M = {}

---@type table<string, string>
M.nixpkgs = {} -- <name>: <path>

---@type table<string, string>
M.bin = {} -- <name>: <path>

---@param name string
---@return string?
function M.resolve_pkg(name)
  return M.nixpkgs[name]
end

---@param name string
---@return string
function M.resolve_bin(name)
  local path = M.bin[name]
  if path == nil then
    return name
  else
    return path
  end
end

---@class dora.config.nix.SetupOption
---@field pkgs? table<string, string>
---@field bin? table<string, string>

---@param opts dora.config.nix.SetupOption
function M.setup(opts)
  M.nixpkgs = opts.pkgs or {}
  M.bin = opts.pkgs or {}
end

return M
