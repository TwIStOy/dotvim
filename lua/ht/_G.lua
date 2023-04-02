local ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = require
if ok then
  reloader = plenary_reload.reload_module
end

RELOAD = function(...)
  local ok, plenary_reload = pcall(require, "plenary.reload")
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
