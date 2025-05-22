---@module 'dotvim.commons.validator'

local M = {}

---Test if value is an array. If validator is provided, it will be used to validate the elements of the array.
---@param value any
---@param validator nil|fun(any): boolean
function M.is_array(value, validator)
  local isarr = vim.isarray(value)
  if isarr and validator then
    for _, v in ipairs(value) do
      if not validator(v) then
        return false
      end
    end
  end
  return isarr
end

---Returns a new validator to test if all given validators are met.
---@param ... (fun(any): boolean)[]
---@return fun(any): boolean
function M.all(...)
  local validators = { ... }
  return function(value)
    for _, validator in ipairs(validators) do
      if not validator(value) then
        return false
      end
    end
    return true
  end
end

return M
