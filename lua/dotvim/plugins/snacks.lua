---@module "dotvim.plugins.snacks"

---@type LazyPluginSpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  enabled = not vim.g.vscode,
  opts = function()
    -- Use the existing dashboard header from the project
    local dashboard_header =
      require("dotvim.pkgs.ui.dashboard").resolve_dashboard_header()
    local icon = require("dotvim.commons.icon")

    return {
      bigfile = { enabled = true },
      dashboard = {
        enabled = vim.fn.argc() == 0
          and vim.o.lines >= 36
          and vim.o.columns >= 80,
        preset = {
          header = table.concat(dashboard_header, "\n"),
          keys = {
            {
              icon = icon.icon("DefaultFile"),
              key = "f",
              desc = "Find File",
              action = function()
                require("dotvim.features.fzf_search").find_files()
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
                require("fzf-lua").oldfiles()
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
          {
            section = "terminal",
            cmd = "krabby random --no-title; sleep .1",
            random = 100,
            pane = 2,
            indent = 4,
            height = 30,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
