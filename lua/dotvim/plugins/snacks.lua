---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  enabled = not vim.g.vscode,
  keys = {
    {
      "<leader>g",
      function()
        require("snacks").lazygit.open()
      end,
      desc = "open-lazygit",
    },
  },
  opts = function()
    local icon = require("dotvim.commons.icon")
    return {
      bigfile = { enabled = true },
      lazygit = {
        configure = true,
      },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
        previewers = {
          file = {
            max_size = 1024 * 1024,
          },
        },
      },
      dashboard = {
        enabled = vim.fn.argc() == 0
          and vim.o.lines >= 36
          and vim.o.columns >= 80,
        preset = {
          keys = {
            {
              icon = icon.icon("DefaultFile"),
              key = "f",
              desc = "Find File",
              action = function()
                require("snacks").picker.files()
              end,
            },
            {
              icon = icon.icon("FileNew"),
              key = "e",
              desc = "New File",
              action = ":ene | startinsert",
            },
            {
              icon = icon.icon("FolderOpen"),
              key = "r",
              desc = "Recent Files",
              action = function()
                require("snacks").picker.recent()
              end,
            },
            {
              icon = icon.icon("ActiveLSP"),
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            {
              icon = icon.icon("ArrowLeft"),
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
        },
        sections = {
          {
            icon = icon.icon("FolderOpen"),
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
            limit = 5,
            cwd = true,
          },
          {
            icon = icon.icon("Git"),
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
            limit = 5,
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    }
  end,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
