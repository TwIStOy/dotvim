---@class dora.lib.func
local M = {}

---@class dora.lib.CacheManager
---@field private entries table<string, any>
local CacheManager = {}

CacheManager.new = function()
	local self = setmetatable({}, { __index = CacheManager })
	self.entries = {}
	return self
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

---@return dora.lib.CacheManager
function M.new_cache_manager()
	return CacheManager.new()
end

---@generic T
---@param fun fun():T
---@return T
function M.call_once(fun)
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

---@generic T
---@param name string
---@param callback fun(module): T
---@return T?
function M.require_then(name, callback)
	local has_module, module = pcall(require, name)
	if has_module then
		return callback(module)
	end
end

---@param callback string|fun(): any
---@param feedkeys? boolean
---@return fun(): any
function M.normalize_callback(callback, feedkeys)
	if type(callback) == "string" then
		if feedkeys == true then
			return function()
				local key = vim.api.nvim_replace_termcodes(callback .. "<Ignore>", true, false, true)
				vim.api.nvim_feedkeys(key, "t", false)
			end
		else
			return function()
				vim.api.nvim_command(callback)
			end
		end
	else
		return callback
	end
end

return M
