local lib = require("dora.lib")
local config = require("dora.config")

---@type dora.lib.PluginOptions
return {
  "m4xshen/smartcolumn.nvim",
  opts = {
    colorcolumn = "80",
    disabled_filetypes = {
      "help",
      "NvimTree",
      "lazy",
      "mason",
      "help",
      "alpha",
      "bookmarks_input",
      "noice",
    },
  },
  event = { "BufReadPre", "BufNewFile" },
  config = true,
}
