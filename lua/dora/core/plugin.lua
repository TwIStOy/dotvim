---@type dora.lib
local lib = require("dora.lib")
---@type dora.config
local config = require("dora.config")
---@type dora.core.action
local action_module = require("dora.core.action")

---@class dora.core.plugin
local M = {}

---@class dora.core.plugin.ExtraPluginOptions
---@field nixpkg? string Whether the plugin will be loaded from nix
---@field gui? "all"|string[] Can be used in which gui environment
---@field actions? dora.core.action.ActionOptions[]|fun():dora.core.action.ActionOptions[]
---@field keys? LazyKeysSpec[]

---@class dora.core.plugin.PluginOptions: dora.core.plugin.ExtraPluginOptions,LazyPluginSpec

---@class dora.core.plugin.Plugin
---@field options dora.core.plugin.PluginOptions
---@field actions dora.core.action.Action[]
local Plugin = {}

---@param option dora.core.plugin.PluginOptions
---@return dora.core.plugin.Plugin
function M.new_plugin(option)
  local actions = {}
  if option.actions ~= nil then
    ---@type dora.core.action.ActionOptions[]
    local values
    if type(option.actions) == "function" then
      values = option.actions()
    else
      values = option.actions --[[@as dora.core.action.ActionOptions[] ]]
    end
    for _, action in ipairs(values) do
      actions[#actions + 1] = action_module.new_action(action)
    end
  end
  return setmetatable({
    options = option,
    actions = actions,
  }, { __index = Plugin })
end

---@return string
function Plugin:name()
  if self.options.name ~= nil then
    return self.options.name
  end
  return self.options[1]
end

---Converts a plugin into a lazy plugin
---@return LazyPluginSpec? opts options for `lazy.nvim`, nil to skip this
function Plugin:into_lazy_spec()
  local current_gui = lib.vim.current_gui()
  if current_gui ~= nil then
    if self.options.gui == nil then
      return nil
    end
    if type(self.options.gui) == "string" then
      if current_gui ~= self.options.gui and self.options.gui ~= "all" then
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
  local lazy =
    lib.tbl.filter_out_keys(self.options, { "nixpkg", "gui", "actions" })

  local enabled = lazy.enabled
  if type(enabled) == "function" then
    enabled = enabled()
  end

  -- if `nixpkg` is set, load this plugin from nix
  if self.options.nixpkg ~= nil then
    local nixpkg = self.options.nixpkg
    local path = config.nixpkgs.resolve_pkg(nixpkg --[[ @as string ]])
    if path ~= nil then
      lazy.dir = path
      lazy.build = nil -- skip build if it's from nix
    end
  end

  if self.actions ~= nil and enabled then
    local all_keys = self.options.keys
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

return M
