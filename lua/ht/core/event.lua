local Event = {}

function Event:new()
  local o = {
    listeners = {},
    once_listeners = {},
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Event:on(event, callback)
  if not self.listeners[event] then
    self.listeners[event] = {}
  end
  table.insert(self.listeners[event], callback)
end

function Event:once(event, callback)
  if not self.once_listeners[event] then
    self.once_listeners[event] = {}
  end
  table.insert(self.once_listeners[event], callback)
end

function Event:emit(event, ...)
  local results = {}
  if self.listeners[event] then
    for _, callback in ipairs(self.listeners[event]) do
      local res = callback(...)
      if res ~= nil then
        results[#results + 1] = res
      end
    end
  end
  if self.once_listeners[event] then
    for _, callback in ipairs(self.once_listeners[event]) do
      local res = callback(...)
      if res ~= nil then
        results[#results + 1] = res
      end
    end
    self.once_listeners[event] = nil
  end
  return results
end

return Event
