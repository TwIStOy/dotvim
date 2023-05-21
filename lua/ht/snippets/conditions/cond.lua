local M = {}

---@class ConditionFuncObject
---@operator unm: ConditionFuncObject
---@operator add(ConditionFuncObject): ConditionFuncObject
---@operator div(ConditionFuncObject): ConditionFuncObject
---@operator pow(ConditionFuncObject): ConditionFuncObject
---@operator call(): boolean
local ConditionFuncObject = {
  -- not '-'
  __unm = function(o1)
    return M.make_condition_func(function(...)
      return not o1(...)
    end)
  end,
  -- and '+'
  __add = function(o1, o2)
    return M.make_condition_func(function(...)
      return o1(...) or o2(...)
    end)
  end,
  -- or '/'
  __div = function(o1, o2)
    return M.make_condition_func(function(...)
      return o1(...) and o2(...)
    end)
  end,
  -- xor '^'
  __pow = function(o1, o2)
    return M.make_condition_func(function(...)
      return o1(...) ~= o2(...)
    end)
  end,
  -- use table like a function by overloading __call
  __call = function(tab, line_to_cursor, matched_trigger, captures)
    return tab.func(line_to_cursor, matched_trigger, captures)
  end,
}

---@class ConditionObject
---@field condition ConditionFuncObject
---@field show_condition ConditionFuncObject
local ConditionObject = {
  ---@param tbl ConditionObject
  ---@return ConditionObject
  __unm = function(tbl)
    return M.make_condition(-tbl.condition, -tbl.show_condition)
  end,
  ---@param o1 ConditionObject
  ---@param o2 ConditionObject
  ---@return ConditionObject
  __add = function(o1, o2)
    return M.make_condition(
      o1.condition + o2.condition,
      o1.show_condition + o2.show_condition
    )
  end,
  ---@param o1 ConditionObject
  ---@param o2 ConditionObject
  ---@return ConditionObject
  __div = function(o1, o2)
    return M.make_condition(
      o1.condition / o2.condition,
      o1.show_condition / o2.show_condition
    )
  end,
  ---@param o1 ConditionObject
  ---@param o2 ConditionObject
  ---@return ConditionObject
  __pow = function(o1, o2)
    return M.make_condition(
      o1.condition ^ o2.condition,
      o1.show_condition ^ o2.show_condition
    )
  end,
}

---@param fn function
---@return ConditionFuncObject
function M.make_condition_func(fn)
  return setmetatable({ func = fn }, ConditionFuncObject)
end

---@param condition function|ConditionFuncObject
---@param show_condition function|ConditionFuncObject
---@return ConditionObject
function M.make_condition(condition, show_condition)
  if type(condition) == "function" then
    condition = M.make_condition_func(condition)
  end
  if type(show_condition) == "function" then
    show_condition = M.make_condition_func(show_condition)
  end

  return setmetatable({
    condition = condition,
    show_condition = show_condition,
  }, ConditionObject)
end

return M
