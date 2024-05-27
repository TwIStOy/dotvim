---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "shellRaining/hlchunk.nvim",
    branch = "dev",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = true,
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
