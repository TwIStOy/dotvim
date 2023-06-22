return {

  Use {
    "wakatime/vim-wakatime",
    lazy = {
      event = "BufRead",
    },
    category = "WakaTime",
    functions = {
      FuncSpec("Echo total coding activity for Today", "WakaTimeToday"),
      FuncSpec(
        "Enable debug mode (may slow down Vim so disable when finished debugging)",
        "WakaTimeDebugEnable"
      ),
      FuncSpec("Disable debug mode", "WakaTimeDebugDisable"),
    },
  },
}
