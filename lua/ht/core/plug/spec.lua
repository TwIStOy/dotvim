local FuncSpec = require("ht.core.plug.func_spec")

---@class PluginFunctionalityFilterSpec
---@field ft string|string[]|nil
---@field filename string|string[]|nil
---@field filter nil|fun(VimBuffer):boolean
local PluginFunctionalityFilterSpec = {}

---@class PluginFunctionalitySpecSet
---@field filter PluginFunctionalityFilterSpec|nil
---@field values PluginFunctionalitySpec[]
local PluginFunctionalitySpecSet = {}

---@class PluginSpec
---@field short_url string|nil
---@field category string|nil
---@field lazy table all options passed to lazy.nvim
---@field functionalities PluginFunctionalitySpecSet[]
local PluginSpec = {}

---@param functions PluginFunctionalitySpecSet[]|PluginFunctionalitySpec[]|PluginFunctionalitySpec|PluginFunctionalitySpecSet
---@return PluginFunctionalitySpecSet[]
local function normalize_func_spec_set(functions)
  if type(functions) ~= "table" then
    return {}
  end
  if not vim.tbl_islist(functions) then
    if functions.title ~= nil then
      -- is PluginFunctionalitySpec
      return { { values = { functions } } }
    else
      -- is PluginFunctionalitySpecSet
      return { functions }
    end
  end

  local res = {}
  for _, item in ipairs(functions) do
    if item.values == nil then
      -- item is PluginFunctionalitySpec
      res[#res + 1] = { values = { item } }
    else
      res[#res + 1] = item
    end
  end

  return res
end

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
local function new_spec(opts)
  local res = {}
  res.short_url = opts[1] or opts.short_url
  if opts.category == nil then
    res.category = guess_category(res.short_url)
  else
    res.category = opts.category
  end
  res.lazy = opts.lazy or {}
  res.functionalities = normalize_func_spec_set(opts.functions)
  setmetatable(res, { __index = PluginSpec })
  return res
end

function PluginSpec:as_lazy_spec()
  local spec = {}
  -- short url
  spec[1] = self.short_url or self[1]
  spec = vim.tbl_extend("force", spec, self.lazy)

  local keys = {}
  for _, func_set in ipairs(self.functionalities) do
    for _, func in ipairs(func_set.values) do
      local v = func:as_lazy_keys()
      if v ~= nil then
        vim.list_extend(keys, v)
      end
    end
  end
  if spec.keys == nil and #keys > 0 then
    spec.keys = keys
  elseif spec.keys ~= nil and #keys > 0 then
    vim.list_extend(spec.keys, keys)
  end

  return spec
end

---@return AddFunctionSetOptions[]
function PluginSpec:as_add_func_opts()
  local specs = {}
  for _, func in ipairs(self.functionalities) do
    local item = {
      category = self.category,
      ft = func.filter and func.filter.ft,
      filename = func.filter and func.filter.filename,
      filter = func.filter and func.filter.filter,
      functions = {},
    }
    for _, f in ipairs(func.values) do
      item.functions[#item.functions + 1] = f:as_func_spec(self.category)
    end
    specs[#specs + 1] = item
  end
  return specs
end

return new_spec
