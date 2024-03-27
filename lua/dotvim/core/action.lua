---@class dotvim.core.action
local M = {}

---@class dotvim.core.action.KeySpec: LazyKeysBase
---@field mode? string|string[]

---@alias dotvim.core.action.Condition fun(buf:dora.lib.vim.BufferWrapper):boolean

---@class dotvim.core.action.ActionOption
---@field id string Unique id
---@field title string
---@field callback string|function
---@field icon? string
---@field category? string
---@field description? string Shown description if action hovered
---@field keys? string|(string|dotvim.core.action.KeySpec)[]
---@field plugin? string
---@field condition? dotvim.core.action.Condition

---@class dotvim.core.action.Action: dotvim.core.action.ActionOption
local Action = {}

function Action:execute()
  local callback = self.callback
  if type(callback) == "string" then
    vim.cmd(callback)
  else
    callback()
  end
end

---@return LazyKeysSpec[]
function Action:into_lazy_keys_spec()
  local keys = self.keys
  if not keys then
    return {}
  end
  local callback = function()
    self:execute()
  end
  if type(keys) == "string" then
    return {
      {
        keys,
        callback,
      },
    }
  end
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
      ---@type dotvim.core.action.KeySpec
      local k = vim.deepcopy(key)
      k[2] = callback
      res[#res + 1] = k
    end
  end

  return res
end

return M
