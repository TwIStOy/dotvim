---@class dotvim.core.plugin
local M = {}

---@class dotvim.core.plugin.ExtraPluginOptions
---@field pname? string nix plugin name
---@field vscode? boolean whether this plugin can be used in vscode-neovim
---@field actions? dotvim.core.action.ActionOption[]|fun():dotvim.core.action.ActionOption[]

---@class dotvim.core.plugin.PluginOption: dotvim.core.plugin.ExtraPluginOptions,LazyPluginSpec

---@class dotvim.core.plugin.Plugin: dotvim.core.plugin.PluginOption,LazyPlugin

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
