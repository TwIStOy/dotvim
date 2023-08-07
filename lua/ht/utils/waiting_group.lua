---@class ht.WaitingGroup
---@field private _waiting_flags table<string, boolean|function|nil>
---@field private _callback function
---@field private _callback_invoked boolean
---@field private _failed boolean
local wg = {}

---@param callback function
---@return ht.WaitingGroup
function wg:new(callback)
  local o = {
    _waiting_flags = {},
    _callback = callback,
    _callback_invoked = false,
    _failed = false,
  }
  setmetatable(o, {
    __index = self,
  })
  return o
end

---@param flag string
---@param cancel function?
function wg:wait(flag, cancel)
  self._waiting_flags[flag] = cancel
end

---@param flag string
function wg:finish(flag)
  self._waiting_flags[flag] = true
  if not self._callback_invoked and not self._failed then
    for _, v in pairs(self._waiting_flags) do
      if v ~= true then
        return
      end
    end
    self._callback_invoked = true
    self._callback()
  end
end

---@param flag string
function wg:fail(flag)
  for f, v in pairs(self._waiting_flags) do
    if f ~= flag and type(v) == "function" then
      v()
    end
  end
end

return wg
