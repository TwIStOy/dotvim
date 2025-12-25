---@type LazyPluginSpec
return {
  "xzbdmw/clasp.nvim",
  opts = {},
  keys = {
    {
      "<M-[>",
      mode = { "i", "n" },
      desc = "Wrap previous",
      function()
        require("clasp").wrap("prev")
      end,
    },
    {
      "<M-]>",
      mode = { "i", "n" },
      desc = "Wrap next",
      function()
        require("clasp").wrap("next")
      end,
    },
  },
}
