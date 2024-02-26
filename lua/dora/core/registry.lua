---@class dora.core.registry
local M = {}

---@type table<string, dora.core.plugin.Plugin>
M.plugins = {}
---@type table<string, dora.core.action.Action>
M.actions = {}

---@param plugin dora.core.plugin.Plugin
function M.register_plugin(plugin)
  M.plugins[plugin:name()] = plugin
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

return M
