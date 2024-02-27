---@class dora.core.package
local M = {}

---@class dora.core.package.PackageOption
---@field name string
---@field deps? string[]
---@field setup? fun():any
---@field plugins? dora.core.plugin.PluginOption[]

---@class dora.core.package.Package
---@field private _ dora.core.package.PackageOption
local Package = {}

function Package:name()
  return self._.name
end

---@param opts dora.core.package.PackageOption
---@return dora.core.package.Package
function M.new_package(opts)
  local p = { _ = opts }
  return setmetatable(p, { __index = Package })
end

return M
