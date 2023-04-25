local U = require 'ht.utils.init'
local is_type = U.is_type
local normalize_vec_str = U.normalize_vec_str

---@class PluginFunctionalityKeymapSpec
---@field keys string[]
---@field modes string[]
local PluginFunctionalityKeymapSpec = {}

---@param opts table|string
---@return PluginFunctionalityKeymapSpec|nil
function PluginFunctionalityKeymapSpec.normalize(opts)
  if is_type('string', opts) then
    return { keys = { opts }, modes = { 'n' } }
  elseif is_type('table', opts) then
    local keys = opts.keys or {}
    local modes = opts.modes or {}
    return { keys = normalize_vec_str(keys), modes = normalize_vec_str(modes) }
  end
end

---@return PluginFunctionalityKeymapSpec
function PluginFunctionalityKeymapSpec.new(opts)
  setmetatable(opts, { __index = PluginFunctionalityKeymapSpec })
  return opts
end

---@return PluginFunctionalityKeymapSpec|nil
local function new_spec(opts)
  opts = PluginFunctionalityKeymapSpec.normalize(opts)
  if opts ~= nil then
    return PluginFunctionalityKeymapSpec.new(opts)
  end
end

return new_spec
