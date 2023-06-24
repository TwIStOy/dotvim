local M = {}

M.event = {
  COLLECT_MASON_PKG = 1,
}

local emitter = require("ht.core.event"):new()

function M.on(event, callback)
  emitter:on(event, callback)
end

function M.once(event, callback)
  emitter:once(event, callback)
end

return M
