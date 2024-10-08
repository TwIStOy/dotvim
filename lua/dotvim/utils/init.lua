---@class dotvim.utils
local M = {}

---Create a "lazy" module.
---Lazy modules are modules that are only loaded its children when accessed.
---@param base string The base module path
function M.lazy_module(base)
  return setmetatable({}, {
    ---@param t table
    ---@param key string
    __index = function(t, key)
      local path = ("%s.%s"):format(base, key)
      local ok, mod = pcall(require, path)
      if not ok then
        error(mod)
      end
      t[key] = mod
      return mod
    end,
  })
end

---@type dotvim.utils.ansi
M.ansi = require("dotvim.utils.ansi")

---@type dotvim.utils.string
M.string = require("dotvim.utils.string")

---@type dotvim.utils.async
M.async = require("dotvim.utils.async")

---@type dotvim.utils.fn
M.fn = require("dotvim.utils.fn")

---@type dotvim.utils.fs
M.fs = require("dotvim.utils.fs")

---@type dotvim.utils.icon
M.icon = require("dotvim.utils.icon")

---@type dotvim.utils.lazy
M.lazy = require("dotvim.utils.lazy")

---@type dotvim.utils.nix
M.nix = require("dotvim.utils.nix")

---@type dotvim.utils.tbl
M.tbl = require("dotvim.utils.tbl")

---@type dotvim.utils.value
M.value = require("dotvim.utils.value")

---@type dotvim.utils.vim
M.vim = require("dotvim.utils.vim")

local which_cache = M.fn.new_cache_manager()

---Get the path to a plugin
---@param name string
---@return string?
function M.which_plugin(name)
  if type(name) ~= "string" then
    return name
  end

  return which_cache:ensure({ "plug", name }, function()
    if M.nix.is_nix_managed() then
      local ret = M.nix.resolve_plugin(name)
      return ret
    end
    return nil
  end)
end

---Get the path to a binary
---@param name string
---@param return_default? boolean
---@return string?
function M.which(name, return_default)
  if type(name) ~= "string" then
    return name
  end

  return_default = vim.F.if_nil(return_default, true)

  return which_cache:ensure(
    { "bin", name, tostring(return_default) },
    function()
      -- try to resolve the binary from PATH
      -- NOTE: mason.nvim has already inject the mason bin path into PATH
      if vim.fn.executable(name) == 1 then
        return name
      end

      if M.nix.is_nix_managed() then
        local ret = M.nix.resolve_bin(name)
        if ret ~= nil then
          return ret
        end
      end

      if return_default then
        return name
      else
        return nil
      end
    end
  )
end

---NOTE: opts will be modified in place
---@param opts table
---@param default_value string
---@param ... string
function M.fix_opts_cmd(opts, default_value, ...)
  local cmd = vim.F.if_nil(vim.tbl_get(opts, ...), default_value)
  cmd = M.which(cmd)
  M.tbl.tbl_set(cmd, opts, ...)
  return opts
end

return M
