return {
  {
    "neanias/everforest-nvim",
    enabled = true,
    lazy = false,
    config = function()
      local everforest = require("everforest")
      everforest.setup {
        italics = true,
        transparent_background_level = 0,
        show_eob = false,
        options = {
          theme = "auto",
        },
        on_highlights = function(hl, palette)
          hl["@lsp.type.comment"] = { link = "Comment" }
          hl["@lsp.type.keyword"] = { link = "Keyword" }
          hl["@lsp.typemod.variable.mutable.rust"] = { underline = true }
          hl["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true }
          hl["IlluminatedWordText"] = { underline = true }
        end,
      }
      everforest.load()
    end,
  },
}
