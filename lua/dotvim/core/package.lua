---@class dotvim.core.package
local M = {}

---@class dotvim.core.package.PackageOption
---@field name string
---@field deps? string[]
---@field setup? fun():any
---@field plugins? dotvim.core.plugin.PluginOption[]

---@class dotvim.core.package.Package
---@field private _ dotvim.core.package.PackageOption
local Package = {}

function Package:name()
  return self._.name
end

---@return string[]
function Package:deps()
  return self._.deps or {}
end

---@return dotvim.core.plugin.PluginOption[]
function Package:plugins()
  return self._.plugins or {}
end

function Package:setup()
  if self._.setup then
    self._.setup()
  end
end

local loaded_packages = {}

---@param opts dotvim.core.package.PackageOption
---@return dotvim.core.package.Package
local function create_package(opts)
  local p = { _ = opts }
  local pkg = setmetatable(p, { __index = Package })
  loaded_packages[pkg:name()] = pkg
  return pkg
end

---@param packages table<string, dotvim.core.package.Package>
---@return dotvim.core.package.Package[]
function M.sort_packages(packages)
  ---@type table<string, string[]>
  local outgoing_edges = {}
  ---@type table<string, number>
  local incoming_counts = {}

  local num_of_packages = 0

  for _, pkg in pairs(packages) do
    for _, dep in ipairs(pkg:deps()) do
      if outgoing_edges[dep] == nil then
        outgoing_edges[dep] = {}
      end
      table.insert(outgoing_edges[dep], pkg:name())
      incoming_counts[pkg:name()] = (incoming_counts[pkg:name()] or 0) + 1
    end
    num_of_packages = num_of_packages + 1
  end
  for name, _ in pairs(packages) do
    if incoming_counts[name] == nil then
      incoming_counts[name] = 0
    end
  end

  local queue = {}
  for name, count in pairs(incoming_counts) do
    if count == 0 then
      table.insert(queue, name)
    end
  end

  if #queue == 0 then
    vim.print(outgoing_edges)
    error("No packages as first")
  end

  ---@type string[]
  local sorted = {}

  while #queue > 0 do
    local name = table.remove(queue, 1)
    table.insert(sorted, name)

    if outgoing_edges[name] then
      for _, outgoing in ipairs(outgoing_edges[name]) do
        incoming_counts[outgoing] = incoming_counts[outgoing] - 1
        if incoming_counts[outgoing] == 0 then
          table.insert(queue, outgoing)
        end
      end
    end
  end

  if #sorted ~= num_of_packages then
    error("Not all packages are sorted")
  end

  local res = {}
  for _, name in ipairs(sorted) do
    res[#res + 1] = packages[name]
  end
  return res
end

---@param name string
---@return dotvim.core.package.Package?
function M.load_package(name)
  if loaded_packages[name] then
    return loaded_packages[name]
  end

  local module = require(("dotvim.packages.%s"):format(name))
  if module == nil then
    vim.notify("Failed to load package module: " .. name, vim.log.levels.WARN)
    return nil
  end

  local pkg = create_package(module)

  -- load dependencies
  for _, dep in ipairs(pkg:deps()) do
    M.load_package(dep)
  end
end

function M.sort_loaded_packages()
  return M.sort_packages(loaded_packages)
end

return M
