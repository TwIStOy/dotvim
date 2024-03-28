---@class dotvim.core.registry
local M = {}

---@type table<string, dotvim.core.action.Action>
M.actions = {}

---@param action dotvim.core.action.Action
M.register_action = function(action)
  M.actions[action.id] = action
end

return M
