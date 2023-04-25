local FuncKeymapSpec = require 'ht.core.plug.keymap_spec'

---@class PluginFunctionalitySpec
---@field title string|nil
---@field callback function
---@field desc string|nil
---@field keys PluginFunctionalityKeymapSpec[]
local PluginFunctionalitySpec = {}

---@return FunctionWithDescription
function PluginFunctionalitySpec:as_func_spec(category)
  return {
    title = self.title,
    category = category,
    description = self.desc,
    f = self.callback,
  }
end

---@return List
function PluginFunctionalitySpec:as_lazy_keys()
  local keys = {}
  for _, spec in ipairs(self.keys) do
    for _, key in ipairs(spec.keys) do
      for _, mode in ipairs(spec.modes) do
        table.insert(keys, { key, self.callback, mode = mode, desc = self.desc })
      end
    end
  end
  return keys
end

---@param title string
---@param callback string|function
---@param opts table<'desc'|'keys', any>|nil
---@return PluginFunctionalitySpec
local function new_spec(title, callback, opts)
  vim.validate {
    title = { title, 'string' },
    callback = { callback, { 'function', 'string' } },
  }
  opts = opts or {}
  local spec = {}
  spec.title = title
  if type(callback) == 'string' then
    spec.callback = function()
      vim.cmd(callback)
    end
  else
    spec.callback = callback
  end
  spec.desc = opts.desc
  local keys = opts.keys or {}
  spec.keys = {}
  if type(keys) == 'string' then
    keys = { keys }
  end
  for _, key in ipairs(keys) do
    local v = FuncKeymapSpec(key)
    if v ~= nil then
      table.insert(spec.keys, v)
    end
  end
  setmetatable(spec, { __index = PluginFunctionalitySpec })
  return spec
end

return new_spec
