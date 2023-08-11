local UtilsCache = require("ht.utils.cache")

---@param buffer VimBuffer
---@return any[]
local function get_cache_key(buffer)
  local base = buffer:to_cache_key()
  local status, retval = pcall(function()
    return require("trouble").is_open()
  end)
  local trouble_is_open = status and retval
  base[#base + 1] = trouble_is_open
  return base
end

---@class ht.command_palette.ItemsCollection
---@field private _dynamic_items ht.command_palette.Item[]
---@field private _static_items ht.command_palette.Item[]
---@field private _cache FuncCache
local ItemsCollection = {}

---@return ht.command_palette.ItemsCollection
function ItemsCollection.new()
  local o = {
    _dynamic_items = {},
    _static_items = {},
    _cache = UtilsCache.new(),
  }
  setmetatable(o, { __index = ItemsCollection })
  return o
end

---@param items ht.command_palette.Item[]
function ItemsCollection:push_items(items)
  for _, item in ipairs(items) do
    if item.dynamic then
      self._dynamic_items[#self._dynamic_items + 1] = item
    else
      self._static_items[#self._static_items + 1] = item
    end
  end
  if #items > 0 then
    self._cache:clear()
  end
end

---@param buffer VimBuffer
---@return ht.command_palette.Item[]
function ItemsCollection:filter(buffer)
  local items = {}
  for _, item in ipairs(self._dynamic_items) do
    if item.enabled(buffer) then
      items[#items + 1] = item
    end
  end

  local cache_key = get_cache_key(buffer)
  local static_items = self._cache:ensure(cache_key, function()
    ---@type ht.command_palette.Item[]
    local res = {}
    for _, item in ipairs(self._static_items) do
      if item.enabled(buffer) then
        res[#res + 1] = item
      end
    end
    return res
  end)
  for _, item in ipairs(static_items) do
    items[#items + 1] = item
  end

  return items
end

return ItemsCollection
