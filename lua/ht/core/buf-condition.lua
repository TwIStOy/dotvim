---@class ht.BufferCondition
---@field _fn fun(buffer: VimBuffer):boolean
---@operator unm: ht.BufferCondition
---@operator add(ht.BufferCondition): ht.BufferCondition
---@operator div(ht.BufferCondition): ht.BufferCondition
---@operator pow(ht.BufferCondition): ht.BufferCondition
---@operator call(VimBuffer): boolean
local BufferCondition = {}

local BufferConditionMeta = {
  ---logic not '-'
  ---@param cond ht.BufferCondition
  ---@return ht.BufferCondition
  __unm = function(cond)
    return BufferCondition.new(function(buffer)
      return not cond(buffer)
    end)
  end,
  ---logic and '+'
  ---@param cond1 ht.BufferCondition
  ---@param cond2 ht.BufferCondition
  ---@return ht.BufferCondition
  __add = function(cond1, cond2)
    return BufferCondition.new(function(buffer)
      return cond1(buffer) and cond2(buffer)
    end)
  end,
  ---logic or '/'
  ---@param cond1 ht.BufferCondition
  ---@param cond2 ht.BufferCondition
  ---@return ht.BufferCondition
  __div = function(cond1, cond2)
    return BufferCondition.new(function(buffer)
      return cond1(buffer) or cond2(buffer)
    end)
  end,
  ---logic xor '^'
  ---@param cond1 ht.BufferCondition
  ---@param cond2 ht.BufferCondition
  ---@return ht.BufferCondition
  __pow = function(cond1, cond2)
    return BufferCondition.new(function(buffer)
      return cond1(buffer) ~= cond2(buffer)
    end)
  end,
  ---@param cond ht.BufferCondition
  ---@param buffer VimBuffer
  ---@return boolean
  __call = function(cond, buffer)
    return cond._fn(buffer)
  end,
}

---@param fn fun(buffer: VimBuffer):boolean
function BufferCondition.new(fn)
  local o = { _fn = fn }
  setmetatable(o, BufferConditionMeta)
  return o
end

function BufferCondition.yes()
  return BufferCondition.new(function()
    return true
  end)
end

return BufferCondition
