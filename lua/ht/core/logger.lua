module('ht.core.logger', package.seeall)

local logging_file = os.getenv('HOME') .. '/.local/share/nvim/ht.log'
local logging = require 'logging'
local __loggers = {}
local log_file

local buffer_mode do
  local dir_separator = _G.package.config:sub(1,1)
  local is_windows = dir_separator == '\\'
  if is_windows then
    -- Windows does not support "line" buffered mode, see
    -- https://github.com/lunarmodules/lualogging/pull/9
    buffer_mode = "no"
  else
    buffer_mode = "line"
  end
end

local function openFile()
  if log_file ~= nil then
    return log_file
  end

  local f = io.open(logging_file, "a")
  if (f) then
    f:setvbuf(buffer_mode)
    log_file = f
  else
    print(string.format('Logging file %s can not be opened for writing', logging_file))
  end
  return f
end

function GetLogger(name)
  if __loggers[name] ~= nil then
    return __loggers[name]
  end

  local log_pattern = "<" .. name .. "> " .. "%date %level] %message\n"
  local logger = logging.new(
    function(self, level, message)
      local f = openFile()
      if not f then
        return nil, "open file failed"
      end

      local s = logging.prepareLogMsg(log_pattern, os.date("%Y-%m-%d %H:%M:%S"), level, message)
      f:write(s)
      return true
    end
  )
  logger:setLevel(logger.INFO)
  __loggers[name] = logger
  return logger
end

-- vim: et sw=2 ts=2

