---@alias dora.config.path.ObsidianVaults string[]

---@class dora.config.hello.HelloOptions
---@field header_text string[]

---@class dora.config.Paths
---@field obsidian_vaults? dora.config.path.ObsidianVaults
---@field lazy? string

---@class dora.config.SetupOptions
---@field paths? dora.config.Paths
---@field lsp? dora.config.lsp.BackendConfig
---@field theme? string
---@field hello? dora.config.hello.HelloOptions
local config = {
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

---@param opts dora.config.SetupOptions
local function setup(opts)
  config = vim.tbl_deep_extend("force", config, opts)

  require("dora.config.keymaps")()
end

return {
  config = config,
  setup = setup,
}
