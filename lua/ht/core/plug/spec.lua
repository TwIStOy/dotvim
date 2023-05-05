local FuncSpec = require("ht.core.plug.func_spec")

---@class PluginSpec
---@field short_url string|nil
---@field category string|nil
---@field lazy table all options passed to lazy.nvim
---@field functionalities PluginFunctionalitySpec[]
local PluginSpec = {}

---@param short_url string
---@return string
local function guess_category(short_url)
  -- split short_url by '/'
  local parts = vim.split(short_url, "/")
  local last_part = parts[#parts]
  if vim.endswith(last_part, ".nvim") then
    last_part = last_part:sub(1, -6)
  elseif vim.endswith(last_part, ".vim") then
    last_part = last_part:sub(1, -5)
  end
  -- capitalize first letter
  last_part = last_part:gsub("^%l", string.upper)
  return last_part
end

---@return PluginSpec
function PluginSpec.new(opts)
  local res = {}
  res.short_url = opts[1] or opts.short_url
  if opts.category == nil then
    res.category = guess_category(res.short_url)
  else
    res.category = opts.category
  end
  res.lazy = opts.lazy or {}
  res.functionalities = opts.functions
  setmetatable(res, { __index = PluginSpec })
  return res
end

function PluginSpec:as_lazy_spec()
  local spec = {}
  -- short url
  spec[1] = self.short_url or self[1]
  spec = vim.tbl_extend("force", spec, self.lazy)

  local keys = {}
  for _, func in ipairs(self.functionalities) do
    local v = func:as_lazy_keys()
    if v ~= nil then
      vim.list_extend(keys, v)
    end
  end
  if spec.keys == nil and #keys > 0 then
    spec.keys = keys
  elseif spec.keys ~= nil and #keys > 0 then
    vim.list_extend(spec.keys, keys)
  end

  return spec
end

---@return FunctionWithDescription[]
function PluginSpec:as_func_spec()
  local specs = {}
  for _, func in ipairs(self.functionalities) do
    table.insert(specs, func:as_func_spec(self.category))
  end
  return specs
end

local function new_spec(opts)
  return PluginSpec.new(opts)
end

return new_spec
