---@module 'dotvim.commons.nix'

---@diagnostic disable: undefined-global

local M = {}

local Fs = require("dotvim.commons.fs")
local Str = require("dotvim.commons.string")

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
  local nix_cmd = { "nix-store", "--query", "--requisites", "/run/current-system" }
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

return M
