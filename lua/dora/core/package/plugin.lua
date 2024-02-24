local lib = require("dora.lib")
local core = {
  action = require("dora.core.action"),
}

---@class dora.core.AdditionalPluginOptions
---@field nixpkg? string Whether the plugin will be loaded from nix
---@field vscode? boolean Whether the plugin can be loaded in vscode environment
---@field actions? dora.core.ActionOptions[]

---@class dora.core.PluginOptions: dora.core.AdditionalPluginOptions,LazyPluginSpec

---@class dora.core.Plugin: dora.core.PluginOptions
---@field actions dora.core.Action[]
local Plugin = {}

---@param option dora.core.PluginOptions
---@return dora.core.Plugin
local function construct_plugin(option)
  local actions = {}
  if option.actions ~= nil then
    for _, action in ipairs(option.actions) do
      actions[#actions + 1] = core.action.construct_action(action)
    end
  end
  option.actions = actions
  return setmetatable(option, { __index = Plugin }) --[[@as dora.core.Plugin]]
end

---Converts a plugin into a lazy plugin
---@return LazyPluginSpec? opts options for `lazy.nvim`, nil to skip this
function Plugin:into_lazy_spec()
  if vim.g.vscode and not self.vscode then
    -- skip this plugin if it's not allowed in vscode
    return nil
  end

  -- only export the fields that are in the base class
  local lazy = lib.tbl.filter_out_keys(self, { "nixpkg", "vscode", "actions" })

  -- if `nixpkg` is set, load this plugin from nix
  if self.nixpkg ~= nil then
    local nixpkg = self.nixpkg
    local path = lib.nix.resolve_pkg_path(nixpkg)
    if path ~= nil then
      lazy.dir = path
    end
  end

  if self.actions ~= nil then
    for _, action in ipairs(self.actions) do
      local keys = action:into_lazy_keys()
      for _, key in ipairs(keys) do
        lazy.keys = lazy.keys or {}
        table.insert(lazy.keys, key)
      end
    end
  end

  return lazy
end

return {
  construct_plugin = construct_plugin,
}
