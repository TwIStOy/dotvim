---@alias dora.config.path.ObsidianVaults string[]

---@class dora.config.hello.HelloOptions
---@field header_text string[]

---@class dora.config.Paths
---@field obsidian_vaults? dora.config.path.ObsidianVaults
---@field lazy? string

---@class dora.config.SetupOptions
---@field obsidian? dora.config.configs.Obsidian
---@field lsp? dora.config.lsp.BackendConfig
---@field theme? string
---@field hello? dora.config.hello.HelloOptions
local config = {
  obsidian = require("dora.config.configs.obsidian"),
  lazy = require("dora.config.configs.lazy"),
  paths = {
    obsidian_vaults = {
      "~/obsidian-data",
    },
    lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  },
  theme = "catppuccin",
  hello = {
    header_text = require("dora.config.hello").header_text,
  },
}

---@class dora.config
---@field config dora.config.SetupOptions
local M = {}

---@return string?
function M.resolve_obsidian_vaults()
  ---@type dora.lib
  local lib = require("dora.lib")

  local paths = lib.tbl.optional_field(M.config, "obsidian", "vaults") or {}
  for _, path in ipairs(paths) do
    local p = vim.fn.resolve(vim.fn.expand(path))
    if vim.fn.isdirectory(p) == 1 then
      return p
    end
  end
  return nil
end

---@param opts dora.config.SetupOptions
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", config, opts)
  require("dora.config.keymaps")()
end

return M
