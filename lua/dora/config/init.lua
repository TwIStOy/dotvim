---@alias dora.config.path.ObsidianVaults string[]

---@class dora.config.Paths
---@field obsidian_vaults dora.config.path.ObsidianVaults

---@class dora.config.SetupOptions
---@field paths dora.config.Paths
local config = {
  paths = {
    obsidian_vaults = {
      "~/obsidian-data",
    },
  },
}

---@param opts dora.config.SetupOptions
local function setup(opts)
  config = vim.tbl_extend("force", config, opts)
end

return {
  config = config,
  setup = setup,
}
