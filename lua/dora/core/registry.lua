---@class dora.core.registry
local M = {}

---@type table<string, dora.core.plugin.Plugin>
M.plugins = {}
---@type table<string, dora.core.action.Action>
M.actions = {}
---@type table<string, string>
M.alias_to_fullname = {}

---@param plugin dora.core.plugin.Plugin
function M.register_plugin(plugin)
  M.plugins[plugin:name()] = plugin
  for _, alias in ipairs(plugin:alias()) do
    M.alias_to_fullname[alias] = plugin:name()
  end
  for _, action in ipairs(plugin.actions) do
    if M.actions[action.id] ~= nil then
      error("Action " .. action.id .. " already exists")
    end
    M.actions[action.id] = action
  end
end

---@param name string
---@return dora.core.plugin.Plugin
function M.get_plugin(name)
  return M.plugins[name]
end

---@param name string
---@return boolean
function M.has(name)
  return M.plugins[name] ~= nil
end

---@return dora.core.plugin.Plugin[]
function M.sort_plugins()
  ---@type table<string, string[]>
  local outgoing_edges = {}
  ---@type table<string, number>
  local incoming_counts = {}

  local num_of_plugins = 0
  for _, plugin in pairs(M.plugins) do
    local deps = plugin:resolve_afters()
    for _, dep in ipairs(deps) do
      local depname = M.alias_to_fullname[dep]
      if depname == nil then
        error("Dependency " .. dep .. " not found")
      end

      if outgoing_edges[depname] == nil then
        outgoing_edges[depname] = {}
      end
      table.insert(outgoing_edges[depname], plugin:name())
      incoming_counts[plugin:name()] = (incoming_counts[plugin:name()] or 0) + 1
    end
    num_of_plugins = num_of_plugins + 1
  end
  for name, _ in pairs(M.plugins) do
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
    error("No plugins as first")
  end

  ---@type string[]
  local sorted = {}

  while #queue > 0 do
    local name = table.remove(queue, 1)
    table.insert(sorted, name)
    if outgoing_edges[name] ~= nil then
      for _, nextname in ipairs(outgoing_edges[name]) do
        incoming_counts[nextname] = incoming_counts[nextname] - 1
        if incoming_counts[nextname] == 0 then
          table.insert(queue, nextname)
        end
      end
    end
  end

  if #sorted ~= num_of_plugins then
    error("Cycle detected")
  end

  return vim.tbl_map(function(name)
    return M.plugins[name]
  end, sorted)
end

return M
