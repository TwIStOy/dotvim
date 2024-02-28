---@class dora.config.integration
local M = {}

---@class dora.config.integration.SetupOptions
---@field enable_yazi? boolean
---@field enable_lazygit? boolean

---@type dora.config.integration.SetupOptions
local default_options = {}

M._ = default_options

---@param opts dora.config.integration.SetupOptions
function M.setup(opts)
  M._ = vim.tbl_deep_extend("force", default_options, opts or {})
end

---@param name string
---@return boolean
function M.enabled(name)
  return not not M._["enable_" .. name]
end

return M
