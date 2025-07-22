---@class dotvim.experiments.option
local M = {}

---@class dotvim.experiments.option.MakeOptionArgs
---@field name string
---@field val_type dotvim.experiments.types.Type
---@field default any
---@field description? string
---@field example? string
---@field merge? fun(prev: any, incoming: any): any
---@field apply? fun(value: any): any

---@class dotvim.experiments.option.Option: dotvim.experiments.option.MakeOptionArgs
local Option = {}

---@param prev any
---@param incoming any
---@return any
function Option:update(prev, incoming)
  M.check_option(self, incoming)
  local new_val
  if self.merge == nil then
    new_val = self.val_type.merge(prev, incoming)
  else
    new_val = self.merge(prev, incoming)
  end
  if self.apply ~= nil then
    return self.apply(new_val)
  else
    return new_val
  end
end

---@param opts dotvim.experiments.option.MakeOptionArgs
function M.make_option(opts)
  return setmetatable(opts, { __index = Option })
end

function M.check_option(option, value)
  if not option.val_type.checker(value) then
    error(string.format("Invalid value for option %s: %s", option.name, value))
  end
end

return M
