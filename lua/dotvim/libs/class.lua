---@class dotvim.libs.class
local M = {}

---@class dotvim.libs.class.Metatable
---@field __class__ dotvim.libs.class.Class
---@field __index table|fun():any
---@field __newindex fun():any
---@field __tostring fun():any

---@class dotvim.libs.class.Class
---@field meta dotvim.libs.class.Metatable
---@field __super__ dotvim.libs.class.Class

---@param meta? table
---@return dotvim.libs.class.Class
function M.new_class(meta)
  local c = { meta = meta or {} }
  c.meta.__index = c.meta
  c.__class__ = c
  return c
end

---@param target dotvim.libs.class.Class
---@param base dotvim.libs.class.Class
function M.extend_class(target, base)
  target.__super__ = base
  local mt = setmetatable({ __index = base }, base)
  local base_metatable = getmetatable(base)
  if base_metatable then
    if type(base_metatable.__index) == "function" then
      mt.__index = base_metatable.__index
    end
    if type(base_metatable.__newindex) == "function" then
      mt.__newindex = base_metatable.__newindex
    end
  end
  setmetatable(target, mt)
  setmetatable(target.meta, base.meta)

  if type(base.meta.__tostring) == "function" then
    target.meta.__tostring = base.meta.__tostring
  end
  if type(base.meta.__index) == "function" then
    target.meta.__index = base.meta.__index
  end
  if type(base.meta.__newindex) == "function" then
    target.meta.__newindex = base.meta.__newindex
  end
end

function M.new_instance(class, ...)
  local instance = setmetatable({}, class.meta)
  if instance.__init__ then
    instance:__init__(...)
  end
  return instance
end

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
