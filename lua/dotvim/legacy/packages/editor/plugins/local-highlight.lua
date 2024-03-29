---@type dora.core.plugin.PluginOption[]
return {
  {
    "tzachar/local-highlight.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      hlgroup = "IlluminatedWordWrite",
      disable_file_types = {
        "nuipopup",
        "rightclickpopup",
        "NvimTree",
        "help",
      },
    },
  },
}
