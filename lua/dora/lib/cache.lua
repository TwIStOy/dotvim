---@class dora.lib.CacheManager
---@field private entries table<string, any>
local CacheManager = {}

CacheManager.new = function()
  local self = setmetatable({}, { __index = CacheManager })
  self.entries = {}
  return self
end

---@return dora.lib.CacheManager
local function new_cache_manager()
  return CacheManager.new()
end

---Get cache value
---@param key string|string[]
---@return any|nil
function CacheManager:get(key)
  key = self:key(key)
  if self.entries[key] ~= nil then
    return self.entries[key]
  end
  return nil
end

---Set cache value explicitly
---@param key string|string[]
---@vararg any
function CacheManager:set(key, value)
  key = self:key(key)
  self.entries[key] = value
end

---Ensure value by callback
---@generic T
---@param key string|string[]
---@param callback fun(): T
---@return T
function CacheManager:ensure(key, callback)
  local value = self:get(key)
  if value == nil then
    local v = callback()
    self:set(key, v)
    return v
  end
  return value
end

---Clear all cache entries
function CacheManager:clear()
  self.entries = {}
end

---Create key
---@param key string|string[]
---@return string
function CacheManager:key(key)
  if type(key) == "table" then
    local res = ""
    for _, v in ipairs(key) do
      if type(v) == "string" then
        res = res .. v
      else
        res = res .. tostring(v)
      end
    end
    return res
  end
  return key
end

---@generic T
---@param fun fun():T
---@return T
local function call_once(fun)
  local res
  local called = false
  return function()
    if not called then
      res = fun()
      called = true
    end
    return res
  end
end

---@class dora.lib.cache
local M = {
  new_cache_manager = new_cache_manager,
  call_once = call_once,
}

return M
