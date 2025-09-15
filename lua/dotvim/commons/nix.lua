---@diagnostic disable: undefined-global

---@module 'dotvim.commons.nix'
local M = {}

local Fs = require("dotvim.commons.fs")
local Str = require("dotvim.commons.string")
local Fn = require("dotvim.commons.fn")

-- Cache for nix plugin packages to avoid repeated nix-store calls
local nix_packages_cache = nil

---Get all installed vim plugin packages from nix
---@return table<string, {path: string}>
function M.get_all_vimplugin_packages()
  -- Return cached result if available
  if nix_packages_cache then
    return nix_packages_cache
  end

  local result = {}

  -- Get nix-managed plugins directly from nix-store
  local nix_cmd =
    { "nix-store", "--query", "--requisites", "/run/current-system" }
  local nix_result = vim.system(nix_cmd, { text = true }):wait()

  if nix_result.code == 0 and nix_result.stdout then
    local nix_plugins = Str.split(nix_result.stdout, "\n", { trimempty = true })

    for _, plugin_path in ipairs(nix_plugins) do
      if plugin_path:find("vimplugin%-") then
        -- Extract plugin name from nix store path
        local plugin_name = plugin_path:match("vimplugin%-(.+)%-")
        if plugin_name then
          result[plugin_name] = {
            path = plugin_path,
          }
        end
      end
    end
  end

  -- Cache the result for subsequent calls
  nix_packages_cache = result
  return result
end

---Clear the nix plugin packages cache
---Forces the next call to get_all_vimplugin_packages to re-query nix-store
function M.clear_vimplugin_cache()
  nix_packages_cache = nil
end

local function in_nix_env()
  -- Check if the NIX_PATH environment variable is set
  if vim.env.NIX_PATH then
    return true
  end

  -- Check if the system is running under NixOS
  local os_release = Fs.read_file("/etc/os-release")
  if os_release and os_release:find("NixOS") then
    return true
  end

  -- Check for Nix-specific directories
  local nix_dirs = { "/run/current-system" }
  for _, dir in ipairs(nix_dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      return true
    end
  end

  return false
end

---Check if the current environment is a Nix environment
M.in_nix_env = Fn.invoke_once(in_nix_env)

local nix_aware_cache = nil
local function load_nix_aware_configs()
  local path = vim.fn.stdpath("config") .. "/nix-aware.json"
  ---@diagnostic disable-next-line: undefined-field
  if not not vim.uv.fs_stat(path) then
    ---@type dotvim.utils
    local content = Fs.read_file(path)
    if content ~= nil then
      return vim.fn.json_decode(content)
    end
  end
  return {}
end

function M.get_nix_aware_config()
  if not nix_aware_cache then
    nix_aware_cache = load_nix_aware_configs()
  end
  return nix_aware_cache
end

return M
