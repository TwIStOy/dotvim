local PlugSpec = require("ht.core.plug.spec")
local FuncSpec = require("ht.core.plug.func_spec")
local FF = require("ht.core.functions")

local M = {}

---@class UseOptions
---@field short_url string|nil
---@field category string|nil
---@field lazy table
---@field functions PluginFunctionalitySpecSet[]|PluginFunctionalitySpec[]|PluginFunctionalitySpec
local UseOptions = {}

local function normalize_str_list(s)
  if s == nil then
    return {}
  end
  if type(s) == "string" then
    return { s }
  elseif type(s) == "table" then
    return s
  end
end

---@param opts UseOptions
function M.use(opts)
  ---@type PluginSpec
  local spec = PlugSpec(opts)
  local lazy_spec = spec:as_lazy_spec()
  local functions = spec:as_add_func_opts()
  local cond = spec.lazy.cond
  if cond == nil or cond() then
    for _, func in ipairs(functions) do
      -- merge ft in lazy_spec and func
      local ft = normalize_str_list(lazy_spec.ft)
      ft = vim.list_extend(ft, normalize_str_list(func.ft))
      ft = require("ht.utils.table").unique(ft)
      if #ft > 0 then
        func.ft = ft
      else
        func.ft = nil
      end

      FF:add_function_set(func)
    end
  end
  return lazy_spec
end

return M
