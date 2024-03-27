---@class dotvim.core.plugin.ExtraPluginOptions
---@field pname? string nix plugin name
---@field gui? "all"|string[] Can be used in which gui environment
---@field actions? dotvim.core.action.ActionOption[]|fun():dotvim.core.action.ActionOption[]

---@class dotvim.core.plugin.PluginOption: dotvim.core.plugin.ExtraPluginOptions,LazyPluginSpec

---@class dotvim.core.plugin.Plugin: dotvim.core.plugin.PluginOption,LazyPlugin
