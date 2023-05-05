---@class FuncCache
---@field entries table<string, any>
local FuncCache = {}

FuncCache.new = function()
  local self = setmetatable({}, { __index = FuncCache })
  self.entries = {}
  return self
end

---Get cache value
---@param key string|string[]
---@return any|nil
function FuncCache:get(key)
  key = self:key(key)
  if self.entries[key] ~= nil then
    return self.entries[key]
  end
  return nil
end

---Set cache value explicitly
---@param key string|string[]
---@vararg any
function FuncCache:set(key, value)
  key = self:key(key)
  self.entries[key] = value
end

---Ensure value by callback
---@generic T
---@param key string|string[]
---@param callback fun(): T
---@return T
function FuncCache:ensure(key, callback)
  local value = self:get(key)
  if value == nil then
    local v = callback()
    self:set(key, v)
    return v
  end
  return value
end

---Clear all cache entries
function FuncCache:clear()
  self.entries = {}
end

---Create key
---@param key string|string[]
---@return string
function FuncCache:key(key)
  if type(key) == "table" then
    return table.concat(key, ":")
  end
  return key
end

return FuncCache
