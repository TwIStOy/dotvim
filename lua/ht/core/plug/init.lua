local PlugSpec = RR("ht.core.plug.spec")
local FuncSpec = RR("ht.core.plug.func_spec")
local FF = require("ht.core.functions")

local M = {}

function M.use(opts)
  ---@type PluginSpec
  local spec = PlugSpec(opts)
  local lazy_spec = spec:as_lazy_spec()
  local functions = spec:as_func_spec()
  local cond = spec.lazy.cond
  if cond == nil or cond() then
    local ft = spec.lazy.ft
    FF:add_function_set { filetype = ft, functions = functions }
  end
  return lazy_spec
end

return M
