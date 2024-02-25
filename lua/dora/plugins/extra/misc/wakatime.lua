local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "wakatime/vim-wakatime",
  event = "BufRead",
  actions = lib.plugin.action.make_options {
    from = "wakatime",
    category = "WakaTime",
    actions = {
      {
        id = "wakatime.today",
        title = "Echo total coding activity for Today",
        callback = "WakaTimeToday",
      },
      {
        id = "wakatime.debug.enable",
        title = "Enable debug mode (may slow down Vim so disable when finished debugging)",
        callback = "WakaTimeDebugEnable",
      },
      {
        id = "wakatime.debug.disable",
        title = "Disable debug mode",
        callback = "WakaTimeDebugDisable",
      },
    },
  },
}
