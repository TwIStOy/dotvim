---@class dora.config
local M = {
  ---@type dora.config.lsp
  lsp = require("dora.config.lsp"),
  ---@type dora.config.nixpkgs
  nixpkgs = require("dora.config.nixpkgs"),
}

---@class dora.config.SetupOptions
---@field lsp? dora.config.lsp.SetupOptions
---@field nixpkgs? table<string, string>

---@param opts dora.config.SetupOptions
function M.setup(opts)
  M.lsp.setup(opts.lsp or {})
  M.nixpkgs.setup(opts.nixpkgs or {})
end
