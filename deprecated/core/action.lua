---@class dotvim.core.action
local M = {}

---@class dotvim.core.action.KeySpec: LazyKeysBase
---@field mode? string|string[]

---@alias dotvim.core.action.Condition fun(buf:dotvim.core.vim.BufferWrapper):boolean

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

function Action:category_length()
  if self.category == nil then
    return 0
  end
  return #self.category
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
  if not vim.isarray(keys) then
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

---@param buffer dotvim.core.vim.BufferWrapper
---@return boolean
function Action:is_valid(buffer)
  local cond = self.condition
  if cond == nil then
    return true
  end
  return cond(buffer)
end

---@class dotvim.core.action._MakeActionOptionsArgs
---@field from? string
---@field category? string
---@field condition? dotvim.core.action.Condition
---@field actions? dotvim.core.action.ActionOption[]

---@param opts dotvim.core.action._MakeActionOptionsArgs
---@return dotvim.core.action.ActionOption[]
function M.make_options(opts)
  local common_opts = {
    plugin = opts.from,
    category = opts.category,
    condition = opts.condition,
  }
  local res = {}
  for _, action in ipairs(opts.actions) do
    res[#res + 1] = vim.tbl_extend("keep", action, common_opts)
  end
  return res
end

---@param opts dotvim.core.action.ActionOption
---@return dotvim.core.action.Action
function M.new_action(opts)
  return setmetatable(opts, { __index = Action }) --[[@as dotvim.core.action.Action]]
end

return M
