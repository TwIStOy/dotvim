local lib = require("dora.lib")

---@class dora.lib.AdditionalPluginOptions
---@field nixpkg? string Whether the plugin will be loaded from nix
---@field gui? string|string[] Can be used in which gui environment
---@field actions? dora.lib.ActionOptions[]|fun():dora.lib.ActionOptions[]
---@field keys? LazyKeysSpec[]

---@class dora.lib.PluginOptions: dora.lib.AdditionalPluginOptions,LazyPluginSpec

---@class dora.lib.Plugin: dora.lib.PluginOptions
---@field actions dora.lib.Action[]
local Plugin = {}

---@param option dora.lib.PluginOptions
---@return dora.lib.Plugin
local function new_plugin(option)
  local actions = {}
  if option.actions ~= nil then
    ---@type dora.lib.ActionOptions[]
    local values
    if type(option.actions) == "function" then
      values = option.actions()
    else
      values = option.actions --[[@as dora.lib.ActionOptions[] ]]
    end
    for _, action in ipairs(values) do
      actions[#actions + 1] = lib.action.new_action(action)
    end
  end
  option.actions = actions
  return setmetatable(option, { __index = Plugin }) --[[@as dora.lib.Plugin]]
end

---Converts a plugin into a lazy plugin
---@return LazyPluginSpec? opts options for `lazy.nvim`, nil to skip this
function Plugin:into_lazy_spec()
  local current_gui = lib.vim.current_gui()
  if current_gui ~= nil then
    if self.gui == nil then
      return nil
    end
    if type(self.gui) == "string" then
      if current_gui ~= self.gui and self.gui ~= "all" then
        return nil
      end
    else
      if
        not vim.list_contains(self.gui --[[ @as string[] ]], current_gui)
      then
        return nil
      end
    end
  end

  -- only export the fields that are in the base class
  ---@type LazyPluginSpec
  local lazy = lib.tbl.filter_out_keys(self, { "nixpkg", "gui", "actions" })

  local enabled = lazy.enabled
  if type(enabled) == "function" then
    enabled = enabled()
  end

  -- if `nixpkg` is set, load this plugin from nix
  if self.nixpkg ~= nil then
    local nixpkg = self.nixpkg
    local path = lib.nix.resolve_pkg_path(nixpkg)
    if path ~= nil then
      lazy.dir = path
      lazy.build = nil -- skip build if it's from nix
    end
  end

  if self.actions ~= nil and enabled then
    local all_keys = self.keys
    for _, action in ipairs(self.actions) do
      local keys = action:into_lazy_keys()
      for _, key in ipairs(keys) do
        all_keys[#all_keys + 1] = key
      end
    end
    lazy.keys = all_keys
  end

  return lazy
end

return {
  new_plugin = new_plugin,
}
