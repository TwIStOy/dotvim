---@class dotvim.utils.nix
local M = {}

---@type dotvim.utils.fn
local Fn = require("dotvim.utils.fn")
---@type dotvim.utils.fs
local Fs = require("dotvim.utils.fs")

---@type fun():string[]
local get_plugin_packages = Fn.invoke_once(function()
  local obj = vim
    .system(
      { "nix-store", "--query", "--requisites", "/run/current-system" },
      { text = true }
    )
    :wait()
  if obj.code == 0 then
    ---@type string[]
    local lines = vim.split(obj.stdout or "", "\n", { trimempty = true })
    local res = {}
    for _, value in ipairs(lines) do
      if value:find("vimplugin-") then
        res[#res + 1] = value
      end
    end
    return res
  else
    return {}
  end
end)

---@type string[]
local deps_nix_managed_vim_plugins = {}
---@type table<string, string>
local deps_nix_managed_binaries = {}
local resolve_bin_cache = Fn.new_cache_manager()

function M.update_nix_plugin_packages()
  local packages = get_plugin_packages()
  Fs.write_file(
    vim.fn.stdpath("data") .. "/nix-plugin-packages",
    table.concat(packages, "\n")
  )
  vim.notify("nix plugin packages updated:\n" .. table.concat(packages, "\n"))
  deps_nix_managed_vim_plugins = packages
end

---@param plugin dotvim.core.plugin.PluginOption
---@return string
function M.normalize_plugin_pname(plugin)
  if plugin.pname == nil then
    return plugin.name
  else
    if type(plugin.pname) == "function" then
      return plugin.pname(plugin)
    elseif type(plugin.pname) == "string" then
      return plugin.pname
    else
      error("invalid pname type")
    end
  end
end

local function load_nix_related_data()
  Fs.read_file_then(
    vim.fn.stdpath("data") .. "/nix-plugin-packages",
    function(data)
      deps_nix_managed_vim_plugins = vim.split(data, "\n", { trimempty = true })
    end
  )
  Fs.read_file_then(vim.fn.stdpath("data") .. "/nix-binaries", function(data)
    local ok, ret = pcall(vim.fn.json_decode, data)
    if ok then
      resolve_bin_cache:clear()
      deps_nix_managed_binaries = ret
    end
  end)
end

local assume_data_loaded = Fn.invoke_once(function()
  load_nix_related_data()
  return nil
end)

---@param name string
---@return string?
M.resolve_plugin = function(name)
  assume_data_loaded()
  for _, pkg in ipairs(deps_nix_managed_vim_plugins) do
    if pkg:find(name, 1, true) then
      return pkg
    end
  end
  return nil
end

---@return boolean
M.has_nix_store = Fn.invoke_once(function()
  return vim.fn.executable("nix-store") == 1
end)

local detect_path_parts = {
  ".nix-profile/bin",
  "/etc/profiles/per-user",
  "/run/current-system/sw/bin",
  "/ni/var/nix/profiles/default/bin",
}

M.is_nix_managed = Fn.invoke_once(function()
  local path = vim.split(vim.fn.getenv("PATH"), ":", { trimempty = true })
  for _, p in ipairs(path) do
    for _, part in ipairs(detect_path_parts) do
      if p:find(part, 1, true) then
        return true
      end
    end
  end
  return false
end)

---@return boolean
M.is_nixos = Fn.invoke_once(function()
  ---@diagnostic disable-next-line: undefined-field
  local version = vim.uv.os_uname().version
  return version:find("NixOs", 1, true) ~= nil
end)

---@param name string
---@return string?
M.resolve_bin = function(name)
  assume_data_loaded()
  return resolve_bin_cache:ensure(name, function()
    local bin = deps_nix_managed_binaries[name]
    if bin then
      return bin
    end
    return nil
  end)
end

return M
