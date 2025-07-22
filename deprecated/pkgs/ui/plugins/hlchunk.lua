---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "shellRaining/hlchunk.nvim",
    branch = "dev",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = true,
        delay = 0,
      },
      indent = {
        enable = false,
      },
      line_num = {
        enable = true,
      },
    },
  },
}
