---@class dotvim.utils.fn
local M = {}

---@generic T
---@param fun fun():T
---@return fun():T
function M.invoke_once(fun)
  local res
  local invoked = false
  return function()
    if not invoked then
      res = fun()
      invoked = true
    end
    return res
  end
end

---@class dotvim.utils.fn.CacheManager
---@field private entries table<string, any>
local CacheManager = {}

CacheManager.new = function()
  local self = setmetatable({}, { __index = CacheManager })
  self.entries = {}
  return self
end

---@param key string|string[]
---@return string
local function normalize_cache_key(key)
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

---Get cache value
---@param key string|string[]
---@return any|nil
function CacheManager:get(key)
  key = normalize_cache_key(key)
  if self.entries[key] ~= nil then
    return self.entries[key]
  end
  return nil
end

---Set cache value explicitly
---@param key string|string[]
---@vararg any
function CacheManager:set(key, value)
  key = normalize_cache_key(key)
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

---Wrap callback with cache
---@generic Args
---@generic T
---@param callback fun(...: Args): T
---@return fun(...: Args): T
function CacheManager:wrap(callback)
  return function(...)
    local args = { ... }
    return self:ensure(args, function()
      return callback(unpack(args))
    end)
  end
end

---Clear all cache entries
function CacheManager:clear()
  self.entries = {}
end

---@return dotvim.utils.fn.CacheManager
function M.new_cache_manager()
  return CacheManager.new()
end

return M
