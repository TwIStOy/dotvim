return {
  -- colorful windows seperators
  { "nvim-zh/colorful-winsep.nvim", event = "VeryLazy" },

  {
    "TwIStOy/right-click.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = true,
  },

  {
    "NvChad/nvim-colorizer.lua",
    ft = {
      "vim",
      "lua",
    },
    opts = {
      filetypes = {
        "vim",
        "lua",
      },
      user_default_options = {
        names = false,
      },
    },
    config = true,
  },

  -- scroll
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = { "BufReadPost" },
    dependencies = { "kevinhwang91/nvim-hlslens" },
    config = function()
      require("scrollbar.handlers.search").setup()
      require("scrollbar").setup {
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
      }
    end,
  },

  -- used for update tmux tabline
  Use {
    "edkolev/tmuxline.vim",
    lazy = { lazy = true, cmd = { "Tmuxline" } },
    functions = { FuncSpec("Update current tmux theme", "Tmuxline") },
  },
}
