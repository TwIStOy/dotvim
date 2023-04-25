---@class PluginFunctionalitySpec
---@field title string|nil
---@field callback function|string
---@field desc string|nil
---@field keys PluginFunctionalityKeymapSpec[]
local PluginFunctionalitySpec = {}

---@return FunctionWithDescription
function PluginFunctionalitySpec.as_func(category)
end
