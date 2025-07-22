---@class dotvim.utils.lazy
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

return M
