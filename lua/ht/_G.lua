RELOAD = function(...)
  local ok, plenary_reload = pcall(require, "plenary.reload")
  local reloader
  if ok then
    reloader = plenary_reload.reload_module
  end

  return reloader(...)
end

--- reload before require
---@param name string
---@return any
RR = function(name)
  RELOAD(name)
  return require(name)
end

NMAP = function(lhs, rhs, desc, _opts)
  local opts = _opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("n", lhs, rhs, opts)
end

VMAP = function(lhs, rhs, desc, _opts)
  local opts = _opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("v", lhs, rhs, opts)
end

ICON = function(code)
  if type(code) == "string" then
    code = tonumber("0x" .. code)
  end
  local c = string.char
  if code <= 0x7f then
    return c(code)
  end
  local t = {}
  if code <= 0x07ff then
    t[1] = c(bit.bor(0xc0, bit.rshift(code, 6)))
    t[2] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  elseif code <= 0xffff then
    t[1] = c(bit.bor(0xe0, bit.rshift(code, 12)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  else
    t[1] = c(bit.bor(0xf0, bit.rshift(code, 18)))
    t[2] = c(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)))
    t[3] = c(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)))
    t[4] = c(bit.bor(0x80, bit.band(code, 0x3f)))
  end
  return table.concat(t)
end

Throttle = function(fn, ms)
  local timer = vim.uv.new_timer()
  local running = false
  return function(...)
    if not running then
      timer:start(ms, 0, function()
        running = false
      end)
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
end

Use = require("ht.core.plug.init").use

FuncSpec = require("ht.core.plug.func_spec")

Exec = function(cmd)
  vim.ui.input({ prompt = "Arguments, " .. cmd }, function(input)
    if input ~= nil then
      if #input > 0 then
        local full_cmd = cmd .. " " .. input
        vim.cmd(full_cmd)
      else
        vim.cmd(cmd)
      end
    end
  end)
end

ExecFunc = function(cmd)
  return function()
    Exec(cmd)
  end
end
