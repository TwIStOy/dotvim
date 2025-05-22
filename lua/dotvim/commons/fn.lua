---@module 'dotvim.commons.fn'
local M = {}

---Returns a function that will only invoke the given function once.
---@generic T
---@param fun fun():T
---@return fun():T
function M.invoke_once(fun)
  local ret
  local invoked = false
  return function()
    if not invoked then
      ret = { fun() }
      invoked = true
    end
    return unpack(ret)
  end
end

---Invoke the given callback after the mod is loaded.
---@generic T
---@generic U
---@param mod string
---@param succ fun(module): T
---@param fail fun(): U
---@return T|U|nil
function M.require_and(mod, succ, fail)
  local has_module, module = pcall(require, mod)
  if has_module then
    if succ ~= nil then
      return succ(module)
    end
  else
    if fail ~= nil then
      return fail()
    end
  end
end

---Returns a forwarding call wrapper for `fn`. Calling this wrapper is equivalent to
---invoking `fn` with some of its arguments bound to args.
---Example:
---```lua
---local fn = function(a, b, c)
---  print(a, b, c)
---end
---local bound_fn = bind(fn, { 1, nil, 3 })
---bound_fn(2) -- prints 1, 2, 3
---```
---@param fn function
---@param args table<number, any> Table of arguments to bind.
---@return function
function M.bind(fn, args)
  vim.validate("fn", fn, "function")
  vim.validate("args", args, function(value)
    return type(value) == "table"
      and require("dotvim.commons.validator").is_array(value, function(v)
        return type(v) == "number"
      end)
  end)

  local max_index = 0
  for i, _ in pairs(args) do
    max_index = math.max(max_index, i)
  end

  return function(...)
    local input_args = { ... }
    local result_args = {}

    local index = 1
    local input_index = 1

    while true do
      if index > max_index and input_index > #input_args then
        break
      end

      if args[index] ~= nil then
        result_args[index] = args[index]
      else
        if input_index <= #input_args then
          result_args[index] = input_args[input_index]
          input_index = input_index + 1
        end
      end
    end

    return fn(unpack(result_args))
  end
end

return M
