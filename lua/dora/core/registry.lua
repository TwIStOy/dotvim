---@class dora.core.registry
local M = {}

---@type table<string, dora.core.plugin.Plugin[]>
M.plugins = {}
---@type table<string, dora.core.action.Action>
M.actions = {}
---@type table<string, string>
M.alias_to_fullname = {}

---@param plugin dora.core.plugin.Plugin
function M.register_plugin(plugin)
  if M.plugins[plugin:name()] == nil then
    M.plugins[plugin:name()] = {}
  end
  table.insert(M.plugins[plugin:name()], plugin)
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
---@return dora.core.plugin.Plugin[]
function M.get_plugin(name)
  return M.plugins[name]
end

---@param name string
---@return boolean
function M.has(name)
  return M.alias_to_fullname[name] ~= nil
end

return M
