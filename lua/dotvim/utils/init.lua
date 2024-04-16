---@class dotvim.utils
local M = {}

---@type dotvim.utils.ansi
M.ansi = require("dotvim.utils.ansi")

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
---@return string
function M.which(name)
  if type(name) ~= "string" then
    return name
  end

  return which_cache:ensure({ "bin", name }, function()
    if M.nix.is_nix_managed() then
      local ret = M.nix.resolve_bin(name)
      if ret ~= nil then
        return ret
      end
    end

    -- nixos should not try to resolve binaries from mason
    if M.nix.is_nixos() then
      return name
    end

    if M.lazy.has("mason.nvim") then
      local mason_root = require("mason.settings").current.install_root_dir
      local path = mason_root .. "/bin/" .. name
      if vim.fn.executable(path) == 1 then
        return path
      end
    end

    return name
  end)
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
