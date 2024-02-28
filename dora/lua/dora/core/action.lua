---@class dora.core.action
local M = {}

---@alias dora.core.action.Condition fun(buf:dora.lib.vim.BufferWrapper):boolean

---@class dora.core.action.Action: dora.core.action.ActionOptions
local Action = {}

---@class dora.core.action.KeySpec: LazyKeysBase
---@field mode? string|string[]

---@class dora.core.action.ActionOptions
---@field id string Unique id
---@field title string
---@field callback string|function
---@field icon? string
---@field category? string
---@field description? string Shown description if action hovered
---@field keys? string|(string|dora.core.action.KeySpec)[]
---@field plugin? string
---@field condition? dora.core.action.Condition

---@class dora.core.action._MakeActionOptionsArgs
---@field from? string
---@field category? string
---@field condition? dora.core.action.Condition
---@field actions? dora.core.action.ActionOptions[]

---@param opts dora.core.action._MakeActionOptionsArgs
---@return dora.core.action.ActionOptions[]
function M.make_options(opts)
  local common_opts = {
    from = opts.from,
    category = opts.category,
    condition = opts.condition,
  }
  local res = {}
  for _, action in ipairs(opts.actions) do
    res[#res + 1] = vim.tbl_extend("keep", action, common_opts)
  end
  return res
end

function Action:execute()
  if type(self.callback) == "string" then
    vim.cmd(self.callback)
  else
    self.callback()
  end
end

---@return LazyKeysSpec[]
function Action:into_lazy_keys()
  if not self.keys then
    return {}
  end
  local callback = function()
    self:execute()
  end
  if type(self.keys) == "string" then
    return {
      {
        self.keys,
        callback,
      },
    }
  end
  local keys = self.keys
  if not vim.tbl_isarray(keys) then
    keys = { keys }
  end

  local res = {}
  for _, key in ipairs(keys) do
    if type(key) == "string" then
      res[#res + 1] = {
        key,
        callback,
      }
    else
      local k = vim.deepcopy(key)
      k[2] = callback
      res[#res + 1] = k
    end
  end

  return res
end

---@param opts dora.core.action.ActionOptions
---@return dora.core.action.Action
function M.new_action(opts)
  return setmetatable(opts, { __index = Action }) --[[@as dora.core.action.Action]]
end

---Returns this action can be used in the given buffer
---@param buffer dora.lib.vim.BufferWrapper
---@return boolean
function Action:enabled(buffer)
  if self.condition then
    return self.condition(buffer)
  end
  return true
end

return M
