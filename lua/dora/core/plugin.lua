local lib = require("dora.lib")

---@class dora.core.AdditionalPluginOptions
---@field nixpkg? string Whether the plugin will be loaded from nix
---@field vscode? boolean Whether the plugin can be loaded in vscode environment

---@class dora.core.PluginOptions: dora.core.AdditionalPluginOptions, LazyPluginBase

---Converts a plugin into a lazy plugin
---@param plugin dora.core.PluginOptions
---@return LazyPlugin
local function intoLazyPlugin(plugin)
  -- only export the fields that are in the base class
  local lazy = lib.tbl.filter_out_keys(plugin, { "nixpkg", "vscode" })

  -- if `nixpkg` is set, load this plugin from nix
  if plugin.nixpkg ~= nil then
    local nixpkg = plugin.nixpkg
    -- TODO(Hawtian Wang): find package from nix
  end
end
