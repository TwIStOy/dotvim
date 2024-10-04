---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "nvchad/ui",
    enabled = false,
    config = function()
      require("nvchad")
    end,
  },
}
