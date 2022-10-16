local M = {}

local debug_mode = false

function M.enable_debug()
  debug_mode = true
end

function M.import(name)
  if debug_mode then
    package.loaded[name] = nil
  end
  return require(name)
end

return M
