---@type dora.core.plugin
local plugin = require("dora.core.plugin")
---@type dora.core.registry
local registry = require("dora.core.registry")

---@class dora.config.plugins
local M = {}

---@class dora.config.plugins.ImportConfig
---@field import string

---@class dora.config.plugins.ModuleOption: dora.config.plugins.ImportConfig,dora.core.plugin.PluginOption

---@return dora.core.plugin.PluginOption[]
local function normalize_plugin_options(plugins)
  if vim.tbl_isarray(plugins) then
    return plugins
  end
  return { plugins }
end

local function load_plugin_module(name)
  local module = require("dora.plugins." .. name)

  if module == nil then
    vim.notify("Failed to load plugin module: " .. name, vim.log.levels.WARN)
    return
  end

  local plugin_opts = normalize_plugin_options(module)
  for _, opts in ipairs(plugin_opts) do
    local plug = plugin.new_plugin(opts)
    registry.register_plugin(plug)
  end
end

---@param module dora.config.plugins.ImportConfig
local function use_import_module(module)
  load_plugin_module(module.import)
end

---@param module dora.core.plugin.PluginOption
local function use_plugin_module(module)
  local plug = plugin.new_plugin(module)
  registry.register_plugin(plug)
end

---@param modules dora.core.plugin.PluginOption[]
local function use_plugins_module(modules)
  for _, value in ipairs(modules) do
    use_plugin_module(value)
  end
end

---@param opts dora.config.plugins.ImportConfig|dora.core.plugin.PluginOption|dora.core.plugin.PluginOption[]
local function use_module(opts)
  vim.validate { opts = { opts, "table" } }

  if opts.import then
    use_import_module(opts --[[@as dora.config.plugins.ImportConfig]])
  elseif vim.tbl_isarray(opts) then
    use_plugins_module(opts)
  else
    use_plugin_module(opts --[[@as dora.core.plugin.PluginOption]])
  end
end

---@param modules dora.config.plugins.ModuleOption[]
function M.setup(modules)
  for _, value in ipairs(modules) do
    use_module(value)
  end
end

return M
