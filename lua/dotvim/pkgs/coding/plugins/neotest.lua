---@type dotvim.core.plugin.PluginOption
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {},
    icons = {
      running_animated = {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"},
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
}
