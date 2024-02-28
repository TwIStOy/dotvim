---@class dora.lib.class
local M = {}

---@class dora.lib.class.Prototype
---@field __class__ dora.lib.class.Class
---@field __index table|fun():any
---@field __newindex fun():any
---@field __tostring fun():any

---@class dora.lib.class.Class
---@field prototype dora.lib.class.Prototype
---@field __super__ dora.lib.class.Class

---@param prototype? table
---@return dora.lib.class.Class
function M.new_class(prototype)
	local c = { prototype = prototype or {} }
	c.prototype.__index = c.prototype
	c.__class__ = c
	return c
end

---@param target dora.lib.class.Class
---@param base dora.lib.class.Class
function M.class_extends(target, base)
	target.__super__ = base
	local mt = setmetatable({ __index = base }, base)
	setmetatable(target, mt)
	local base_metatable = getmetatable(base)
	if base_metatable then
		if type(base_metatable.__index) == "function" then
			mt.__index = base_metatable.__index
		end
		if type(base_metatable.__newindex) == "function" then
			mt.__newindex = base_metatable.__newindex
		end
	end
	setmetatable(target.prototype, base.prototype)

	if type(base.prototype.__index) == "function" then
		target.prototype.__index = base.prototype.__index
	end
	if type(base.prototype.__newindex) == "function" then
		target.prototype.__newindex = base.prototype.__newindex
	end
	if type(base.prototype.__tostring) == "function" then
		target.prototype.__tostring = base.prototype.__tostring
	end
end

---@param class dora.lib.class.Class
---@param ... any
function M.new_instance(class, ...)
	local instance = setmetatable({}, class.prototype)
	if instance.__init__ then
		instance:__init__(...)
	end
	return instance
end

---@param obj any
---@param class dora.lib.class.Class
---@return boolean
function M.instanceof(obj, class)
	if type(obj) ~= "table" or type(class) ~= "table" then
		return false
	end
	local cls = obj.__class__
	while cls ~= nil do
		if cls == class then
			return true
		end
		cls = cls.__super__
	end
	return false
end

return M
