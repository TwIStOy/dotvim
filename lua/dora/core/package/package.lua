local core = {
  action = require("dora.core.action"),
  plugin = require("dora.core.package.plugin"),
}

---@class dora.core.package.Meta
---@field nixpkg? string Path to the nix package if the plugin is loaded from nix
---@field ui? string[] Which UIs the plugin supports, default: {"nvim"}
---@field description? string Description of the plugin

---@class dora.core.package.Outputs
---@field actions dora.core.LazyExpr<dora.core.Action[]>
---@field plugins dora.core.LazyExpr<LazyPluginSpec[]>
---@field health fun():boolean health check functions

---@class dora.core.Package
---@field meta dora.core.package.Meta
---@field outputs dora.core.package.Outputs
---@field private _plugins dora.core.Plugin[]
local Package = {}

---@class dora.core.package.Inputs
---@field meta? dora.core.package.Meta
---@field actions? dora.core.ActionOptions[]
---@field plugins? dora.core.PluginOptions[]
---@field health? fun():boolean

local function handle_override_values(table, key, value)
  assert(key == "override")
  -- TODO(Hawtian Wang): support overrides
end

local function new_index_handler(table, key, value)
  if key == "override" then
    handle_override_values(table, key, value)
  end
end

---@param opts dora.core.package.Inputs
---@return dora.core.Package
local function makePackage(opts)
  ---@type dora.core.Plugin[]
  local plugins = vim.tbl_map(function(plug)
    return core.plugin.construct_plugin(plug)
  end, opts.plugins or {})

  ---@type fun(): dora.core.Action[]
  local resolve_actions = function()
    local actions = vim.tbl_map(function(opt)
      return core.action.construct_action(opt)
    end, opts.actions or {})
    for _, plugin in ipairs(plugins) do
      vim.list_extend(actions, plugin.actions)
    end
    return actions
  end

  local resolve_lazy_specs = function()
    return vim.tbl_map(function(plug)
      return plug:into_lazy_spec()
    end, plugins)
  end

  ---@type dora.core.Package
  local res = {
    meta = opts.meta or {},
    _plugins = plugins,
    outputs = {
      actions = resolve_actions,
      plugins = resolve_lazy_specs,
      health = opts.health or function()
        return true
      end,
    },
  }
  return setmetatable(res, {
    __index = Package,
    __newindex = new_index_handler,
  })
end

return makePackage
