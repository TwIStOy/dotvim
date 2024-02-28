---@type dora.core.plugin.PluginOption[]
return {
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Neogen" },
    opts = {
      input_after_comment = false,
      snippet_engine = "luasnip",
    },
    actions = {
      {
        id = "neogen.generate-annotation",
        title = "Generate annotation on this",
        icon = "📝",
        callback = function()
          require("neogen").generate()
        end,
        condition = function(buf)
          return #buf.ts_highlighter > 0
        end,
        category = "Neogen",
      },
    },
  },
}
