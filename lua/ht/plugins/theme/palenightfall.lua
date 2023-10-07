return {
  {
    "JoosepAlviste/palenightfall.nvim",
    enabled = false,
    config = function()
      local colors = require("palenightfall").colors
      require("palenightfall").setup {
        highlight_overrides = {
          ["@lsp.type.comment"] = { link = "Comment" },
          ["@lsp.type.keyword"] = { link = "Keyword" },
          ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true },
        },
      }
    end,
  },
}
