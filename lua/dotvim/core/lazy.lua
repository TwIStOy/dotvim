---@class dotvim.core.lazy
local M = {}

---@type dotvim.utils.fn
local Fn = require("dotvim.utils.fn")

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param plugin string
---@return boolean
function M.loaded(plugin)
  local p = require("lazy.core.config").spec.plugins[plugin]
  if p == nil then
    return false
  end
  return not not p._.loaded
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@type fun()
M.fix_valid_fields = Fn.invoke_once(function()
  local health = require("lazy.health")
  --- pname: package name
  health.valid[#health.valid + 1] = "pname"
  --- actions: exported actions
  health.valid[#health.valid + 1] = "actions"
  --- vscode: whether this plugin can be used in vscode-neovim
  health.valid[#health.valid + 1] = "vscode"
  return nil
end)

---@param callback function
function M.setup_on_lazy_plugins(callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyPlugins",
    callback = callback,
  })
end

---@param plugin dotvim.core.plugin.PluginOption
---@return string
local function guess_name(plugin)
  -- if has '/', use the second part as name
  if plugin.name ~= nil then
    return plugin.name
  elseif string.find(plugin[1], "/") then
    return string.match(plugin[1], ".*/(.*)")
  else
    return plugin[1]
  end
end

---@param plugin dotvim.core.plugin.PluginOption
---@param processed table<string, boolean>
---@return dotvim.core.plugin.PluginOption
function M.fix_cond(plugin, processed)
  local in_vscode = not not vim.g.vscode
  local name = guess_name(plugin)
  if processed[name] then
    return plugin
  end
  processed[name] = true

  if not in_vscode then
    -- leave unchanged if not in vscode
    return plugin
  end

  if plugin.vscode == true then
    -- leave unchanged if vscode is true
    return plugin
  end

  plugin.cond = function()
    return false
  end

  return plugin
end

return M
