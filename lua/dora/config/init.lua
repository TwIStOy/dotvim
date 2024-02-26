---@class dora.config
local M = {
  ---@type dora.config.lsp
  lsp = require("dora.config.lsp"),
}

---@class dora.config.SetupOptions
---@field lsp? dora.config.lsp.SetupOptions

---@param opts dora.config.SetupOptions
function M.setup(opts)
  M.lsp.setup(opts.lsp or {})
end
