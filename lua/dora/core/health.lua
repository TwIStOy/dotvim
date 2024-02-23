---@type string[]
local _tools = {}

---@param value string
local function add_tools(value)
  _tools[#_tools + 1] = value
end

---Returns if the given exe is executable
---@param exe string
---@return boolean
local function executable(exe)
  return vim.fn.executable(exe) == 1
end

---@param ... any
---@return string
local function _stringify_args(...)
  local args = vim.tbl_map(function(v)
    if type(v) ~= "string" then
      return vim.inspect(v)
    end
    return v
  end, { ... })
  return table.concat(args, " ")
end

local function report_ok(...)
  return vim.health.ok(_stringify_args(...))
end

local function report_warn(...)
  return vim.health.warn(_stringify_args(...))
end

local function _check_tools()
  for _, tool in ipairs(_tools) do
    if executable(tool) then
      report_ok(tool .. " installed")
    else
      report_warn(tool .. " not installed?")
    end
  end
end

return setmetatable({
  check = function()
    vim.health.start("dora")
    _check_tools()
  end,
}, {
  __newindex = function(_, key, value)
    if key == "add_tools" then
      add_tools(value)
    end
  end,
})
