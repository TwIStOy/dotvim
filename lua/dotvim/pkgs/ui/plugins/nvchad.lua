---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "nvchad/ui",
    config = function()
      require("nvchad")
    end,
  },
}
