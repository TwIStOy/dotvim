---@class dotvim.core.registry
local M = {}

---@type dotvim.utils.fn
local Fn = require("dotvim.utils.fn")
---@type dotvim.core.vim
local Vim = require("dotvim.core.vim")

---@type table<string, dotvim.core.action.Action>
local actions = {}

local buf_actions_cache = Fn.new_cache_manager()

---@param action dotvim.core.action.Action
M.register_action = function(action)
  actions[action.id] = action
end

---@param name string
M.execute_action = function(name)
  local action = actions[name]
  if action == nil then
    vim.notify("Action not found: " .. name)
    return
  end
  action:execute()
end

---@param buffer? dotvim.core.vim.BufferWrapper
---@return dotvim.core.action.Action[]
M.buf_get_all_actions = function(buffer)
  if buffer == nil then
    local buf = vim.api.nvim_get_current_buf()
    buffer = Vim.wrap_buffer(buf)
  end
  return buf_actions_cache:ensure(buffer:as_cache_key(), function()
    ---@type dotvim.core.action.Action[]
    local ret = {}
    for _, action in pairs(actions) do
      if action:is_valid(buffer) then
        ret[#ret + 1] = action
      end
    end
    return ret
  end)
end

return M
