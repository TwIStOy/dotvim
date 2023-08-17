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

NMAP = function(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("n", lhs, rhs, opts)
end

VMAP = function(lhs, rhs, desc, opts)
  opts = opts or {}
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

TestLog = function(s)
  local file = io.open("/tmp/test.log", "a")
  if type(s) == "table" then
    s = vim.inspect(s)
  elseif type(s) ~= "string" then
    s = tostring(s)
  end
  if file ~= nil then
    file:write(s .. "\n")
    file:close()
  end
end

TestQuery = function()
  local UtilsTs = require("ht.utils.ts")
  -- local query = vim.treesitter.query.parse("cpp", "(call_expression) @my_call")
  local ft = vim.api.nvim_buf_get_option(0, "ft")
  local lang = vim.treesitter.language.get_lang(ft)
  local parser = vim.treesitter.get_parser(0, lang)
  local root = parser:parse()[1]:root()

  local query = vim.treesitter.query.get(lang, "textobjects")

  local matches = query:iter_matches(root, 0, 0, -1)

  while true do
    local pattern, match = matches()
    if pattern == nil then
      break
    end
    for id, node in pairs(match) do
      if query.captures[id] == "parameter.inner" then
        print(query.captures[id], UtilsTs.inspect_node(node))
      end
    end
  end
end

