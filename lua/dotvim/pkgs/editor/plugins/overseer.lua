---@type dotvim.core.plugin.PluginOption
return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  opts = {
    templates = {
      "dotvim.just",
    },
  },
  keys = {
    {
      "<F9>",
      function()
        require("overseer").run_template { name = "just" }
      end,
    },
    {
      "<F10>",
      function()
        require("overseer").run_template { name = "just test" }
      end,
    },
  },
}
