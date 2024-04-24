---@type dotvim.core.plugin.PluginOption
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = true,
  cmd = { "Neotest" },
  opts = {
    adapters = {},
    icons = {
      running_animated = {
        "⣾",
        "⣽",
        "⣻",
        "⢿",
        "⡿",
        "⣟",
        "⣯",
        "⣷",
      },
      passed = "󰄳",
      running = "󰁪",
      failed = "󰅙",
      skipped = "󱧧",
      unknown = "󰀨",
      non_collapsible = "─",
      collapsed = "─",
      expanded = "╮",
      child_prefix = "├",
      final_child_prefix = "╰",
      child_indent = "│",
      final_child_indent = " ",
      watching = "",
      notify = "",
    },
  },
  actions = function()
    ---@type dotvim.core
    local Core = require("dotvim.core")

    ---@type dotvim.utils
    local Utils = require("dotvim.utils")

    ---@type dotvim.core.action
    local Action = require("dotvim.core.action")

    ---@type dotvim.core.action.ActionOption[]
    local actions = {
      {
        id = "neotest.run-suit",
        title = "Run test suit",
        callback = function()
          require("neotest").run.run { suite = true }
        end,
        keys = { "<leader>ta", desc = "run-test-suit" },
      },
      {
        id = "neotest.run-current-file",
        title = "Run tests in current file",
        callback = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        id = "neotest.run-nearest",
        title = "Run nearest test",
        callback = function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        keys = { "<leader>tn", desc = "run-nearest-test" },
      },
      {
        id = "neotest.rerun-last",
        title = "Run nearest test",
        callback = function()
          require("neotest").run.run_last()
        end,
        keys = { "<leader>tr", desc = "rerun-last" },
      },
      {
        id = "neotest.toggle-summary",
        title = "Toggle neotest summary",
        callback = function()
          require("neotest").summary.toggle()
        end,
        keys = { "<leader>ts", desc = "neotest-summary" },
      },
    }

    return Action.make_options {
      from = "neotest",
      category = "Neotest",
      actions = actions,
    }
  end,
}
