local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "jedrzejboczar/possession.nvim",
  cmd = {
    "SSave",
    "SLoad",
    "SDelete",
    "SList",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  opts = {
    silent = true,
    commands = {
      save = "SSave",
      load = "SLoad",
      delete = "SDelete",
      list = "SList",
    },
  },
  actions = lib.plugin.action.make_options {
    from = "possession.nvim",
    category = "possession",
    actions = {
      {
        id = "possession.save",
        title = "Save session",
        callback = "SSave",
      },
      {
        id = "possession.load",
        title = "Load session",
        callback = "SLoad",
      },
      {
        id = "possession.delete",
        title = "Delete session",
        callback = "SDelete",
      },
      {
        id = "possession.list",
        title = "List sessions",
        callback = "SList",
      },
    },
  },
}
