---@class dora.lib.object
local M = {}

---@class dora.lib.object.class.Prototype
---@field constructor dora.lib.object.Class

---@class dora.lib.object.Class
---@field prototype dora.lib.object.class.Prototype
---@field ____super dora.lib.object.Class
---@operator call:...any

---Check if the object is an instance of a class
---@param object table
---@param class table
---@return boolean
function M.isinstance(object, class)
  if type(object) ~= "table" or type(class) ~= "table" then
    return false
  end
  local cls = object.__class__
  while cls ~= nil do
    if cls == class then
      return true
    end
    cls = cls.__super__
  end
end

---Create a new class
---@param supers? dora.lib.object.Class
---@return dora.lib.object.Class
function M.new_class(super)
  local c = { prototype = {} }
  c.prototype.__index = c.prototype
  c.prototype.__class__ = c
  c.prototype.__super__ = super
  return c
end

---Create a new instance of a class
---@param cls dora.lib.object.Class
---@param ... any
function M.new(cls, ...)
  local instance = setmetatable({}, cls.prototype)
  if instance.__init__ ~= nil then
    instance:__init__(...)
  end
  return instance
end

-- local function __TS__InstanceOf(obj, classTbl)
--     if type(classTbl) ~= "table" then
--         error("Right-hand side of 'instanceof' is not an object", 0)
--     end
--     if classTbl[Symbol.hasInstance] ~= nil then
--         return not not classTbl[Symbol.hasInstance](classTbl, obj)
--     end
--     if type(obj) == "table" then
--         local luaClass = obj.constructor
--         while luaClass ~= nil do
--             if luaClass == classTbl then
--                 return true
--             end
--             luaClass = luaClass.____super
--         end
--     end
--     return false
-- end

return M
