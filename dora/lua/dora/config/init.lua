---@class dora.config
local M = {
  ---@type dora.config.lsp
  lsp = require("dora.config.lsp"),
  ---@type dora.config.nix
  nix = require("dora.config.nix"),
  ---@type dora.config.icon
  icon = require("dora.config.icon"),
  ---@type dora.config.package
  package = require("dora.config.package"),
  ---@type dora.config.ui
  ui = require("dora.config.ui"),
  ---@type dora.config.vim
  vim = require("dora.config.vim"),
  ---@type dora.config.integration
  integration = require("dora.config.integration"),
}

---@class dora.config.SetupOptions
---@field lsp? dora.config.lsp.SetupOptions
---@field nix? dora.config.nix.SetupOption
---@field icons? table<string, string>
---@field ui? dora.config.ui.SetupOptions
---@field packages? string[]
---@field vim? dora.config.vim.SetupOption

---@param opts dora.config.SetupOptions
function M.setup(opts)
  M.lsp.setup(opts.lsp or {})
  M.nix.setup(opts.nix or {})
  M.icon.setup(opts.icons or {})
  M.ui.setup(opts.ui or {})
  M.vim.setup(opts.vim or {})

  M.package.setup(opts.packages or {})
end

return M
