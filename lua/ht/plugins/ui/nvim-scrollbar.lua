return {
  -- scroll
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = { "BufReadPost" },
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "folke/tokyonight.nvim",
    },
    opts = {},
    config = function()
      local colors = require("tokyonight.colors").setup()

      require("scrollbar.init").setup {
        show = true,
        show_in_active_only = true,
        set_highlights = true,
        hide_if_all_visible = true,
        excluded_buftypes = { "terminal" },
        excluded_filetypes = {
          "prompt",
          "TelescopePrompt",
          "noice",
          "toggleterm",
          "nuipopup",
          "NvimTree",
          "rightclickpopup",
        },
        handlers = { diagnostic = true, search = true, gitsigns = false },
        handle = {
          color = colors.bg_highlight,
        },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
      }

      require("scrollbar.handlers.search").setup {
        -- hlslens config overrides
      }
    end,
  },
}
