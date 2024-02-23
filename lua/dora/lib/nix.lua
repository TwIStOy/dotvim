--- Nix related functions

--- Resolve the path of a package in the nix store
--- @param name string
--- @return string?
local function resolve_pkg_path(name)
  -- TODO(Hawtian Wang): impl this
end

return {
  resolve_pkg_path = resolve_pkg_path,
}
