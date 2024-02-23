---@class dora.core.ActionKeySpec: LazyKeysBase
---@field mode? string|string[]

---@class dora.core.ActionOptions
---@field id string Unique id
---@field title string
---@field callback string|function
---@field icon? string
---@field category? string
---@field description? string Shown description if action hovered
---@field keys? string|(string|dora.core.ActionKeySpec)[]
---@field plugin? string
---@field condition? fun(buf: dora.lib.vim.Buffer): boolean

---@class dora.core.Action: dora.core.ActionOptions
local Action = {}

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
  ---@param key dora.core.ActionKeySpec|string
  return vim.tbl_map(function(key)
    if type(key) == "string" then
      return {
        key,
        callback,
      }
    else
      local res = vim.deepcopy(key)
      res[2] = callback
      return res
    end
  end, self.keys --[[@as (string|dora.core.ActionKeySpec)[] ]])
end

---Returns this action can be used in the given buffer
---@param buffer dora.lib.vim.Buffer
---@return boolean
function Action:enabled(buffer)
  if self.condition then
    return self.condition(buffer)
  end
  return true
end

return {
  ---@param opts dora.core.ActionOptions
  ---@return dora.core.Action
  construct_action = function(opts)
    return setmetatable(opts, { __index = Action }) --[[@as dora.core.Action]]
  end,
}
