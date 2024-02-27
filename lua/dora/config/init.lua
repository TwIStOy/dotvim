---@class dora.config
local M = {
  ---@type dora.config.lsp
  lsp = require("dora.config.lsp"),
  ---@type dora.config.nixpkgs
  nixpkgs = require("dora.config.nixpkgs"),
  ---@type dora.config.icon
  icon = require("dora.config.icon"),
}

---@class dora.config.SetupOptions
---@field lsp? dora.config.lsp.SetupOptions
---@field nixpkgs? table<string, string>
---@field icons? table<string, string>

---@param opts dora.config.SetupOptions
function M.setup(opts)
  M.lsp.setup(opts.lsp or {})
  M.nixpkgs.setup(opts.nixpkgs or {})
  M.icon.setup(opts.icons or {})
end
