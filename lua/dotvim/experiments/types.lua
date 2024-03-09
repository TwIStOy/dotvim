---@class dotvim.experiments.types
local M = {}

---@class dotvim.experiments.types.Type
---@field name string
---@field checker fun(value: any): boolean Check if the value is of this type
---@field merge fun(prev: any, incoming: any): any Merge the value with the default value
local Type = {}

---@param opts dotvim.experiments.types.Type
function Type.new(opts)
  return setmetatable(opts, { __index = Type })
end

-------------------------------------
-- Simple types
-------------------------------------
M.str = Type.new {
  name = "string",
  checker = function(value)
    return type(value) == "string"
  end,
  merge = function(prev, incoming)
    return vim.F.if_nil(incoming, prev)
  end,
}

M.num = Type.new {
  name = "number",
  checker = function(value)
    return type(value) == "number"
  end,
  merge = function(prev, incoming)
    return vim.F.if_nil(incoming, prev)
  end,
}

M.bool = Type.new {
  name = "boolean",
  checker = function(value)
    return type(value) == "boolean"
  end,
  merge = function(prev, incoming)
    return vim.F.if_nil(incoming, prev)
  end,
}

M.anything = Type.new {
  name = "anything",
  checker = function()
    return true
  end,
  merge = function(prev, incoming)
    return vim.F.if_nil(incoming, prev)
  end,
}

-------------------------------------
-- Complex types
-------------------------------------
---@param type dotvim.experiments.types.Type
function M.list_of(type)
  return Type.new {
    name = "list_of_" .. type.name,
    checker = function(value)
      if type(value) ~= "table" or not vim.tbl_islist(value) then
        return false
      end
      for _, v in ipairs(value) do
        if not type.checker(v) then
          return false
        end
      end
      return true
    end,
    merge = function(prev, incoming)
      local ret = {}
      vim.list_extend(ret, prev)
      vim.list_extend(ret, incoming)
      return ret
    end,
  }
end

---@param type dotvim.experiments.types.Type
function M.dict_of(type)
  return Type.new {
    name = "dict_of_" .. type.name,
    checker = function(value)
      if type(value) ~= "table" then
        return false
      end
      for _, v in pairs(value) do
        if not type.checker(v) then
          return false
        end
      end
      return true
    end,
    merge = function(prev, incoming)
      return vim.tbl_deep_extend("force", prev, incoming)
    end,
  }
end

return M
