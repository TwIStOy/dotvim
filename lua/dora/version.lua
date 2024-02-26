local VERSION_MAJOR = 1
local VERSION_MINOR = 0
local VERSION_PATCH = 0

local function version()
  return string.format("%d.%d.%d", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH)
end

return {
  version = version,
}
