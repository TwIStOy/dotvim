---@alias dora.config.path.ObsidianVaults string[]

---@class dora.config.Paths
---@field obsidian_vaults dora.config.path.ObsidianVaults

---@class dora.config.SetupOptions
---@field paths? dora.config.Paths
---@field lsp? dora.config.lsp.BackendConfig
---@field theme? string
local config = {
  paths = {
    obsidian_vaults = {
      "~/obsidian-data",
    },
  },
  theme = "catppuccin",
}

---@param opts dora.config.SetupOptions
local function setup(opts)
  config = vim.tbl_extend("force", config, opts)

  require("dora.config.keymaps")()
end

return {
  config = config,
  setup = setup,
}
