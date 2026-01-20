local M = {}

function M.fix_valid_fields()
  local health = require("lazy.health")
  --- pname: package name
  health.valid[#health.valid + 1] = "pname"
end

function M.resolve_pkg_name(plugin)
  if plugin.pname ~= nil then
    return plugin.pname
  else
    local name = plugin.name or ""
    -- replace '.' with '-'
    local ret, _ = name:gsub("%.", "-")
    return ret
  end
end

return M
