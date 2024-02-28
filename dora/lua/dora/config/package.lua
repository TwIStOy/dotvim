---@class dora.config.package
local M = {}

---@type table<string, dora.core.package.Package>
M._ = {}

local function load_package(name)
  ---@type dora.core.package
  local Package = require("dora.core.package")

  if M._[name] then
    return
  end

  ---@type dora.core.package.PackageOption
  local module = require(name)
  if module == nil then
    vim.notify("Failed to load package module: " .. name, vim.log.levels.WARN)
    return
  end

  local pkg = Package.new_package(module)
  M._[name] = pkg

  for _, dep in ipairs(pkg:deps()) do
    load_package(dep)
  end
end

---@param pkgs string[]
function M.setup(pkgs)
  for _, dep in ipairs(pkgs) do
    load_package(dep)
  end
end

---@return dora.core.package.Package[]
function M.sorted_package()
  ---@type table<string, string[]>
  local outgoing_edges = {}
  ---@type table<string, number>
  local incoming_counts = {}

  local num_of_packages = 0

  for _, pkg in pairs(M._) do
    for _, dep in ipairs(pkg:deps()) do
      if outgoing_edges[dep] == nil then
        outgoing_edges[dep] = {}
      end
      table.insert(outgoing_edges[dep], pkg:name())
      incoming_counts[pkg:name()] = (incoming_counts[pkg:name()] or 0) + 1
    end
    num_of_packages = num_of_packages + 1
  end
  for name, _ in pairs(M._) do
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
    res[#res + 1] = M._[name]
  end
  return res
end

return M
