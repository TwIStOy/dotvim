---@class dotvim.utils.async
local M = {}

---@param f fun(...):any
---@param ... any
function M.coroutinize(f, ...)
  local co = coroutine.create(f)

  local function _immediate(...)
    local ok, data = coroutine.resume(co, ...)
    if not ok then
      error(debug.traceback(co, data))
    end
    if coroutine.status(co) ~= "dead" then
      return data(_immediate)
    end
  end

  return _immediate(...)
end

---@param f fun(resolve:fun(...:any):any):any
function M.await(f)
  local co = coroutine.running()
  local ret

  f(function(...)
    if coroutine.status(co) == "running" then
      ret = { ... }
    else
      return coroutine.resume(co, ...)
    end
  end)

  if ret then
    return unpack(ret)
  else
    return coroutine.yield()
  end
end

function M.wrap(f)
  return function(...)
    local args = { ... }
    return M.await(function(resolve)
      args[#args + 1] = resolve
      f(unpack(args))
    end)
  end
end

return M
