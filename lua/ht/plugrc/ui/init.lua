return {
  { import = "ht.plugrc.ui.window-picker" },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- popup library
  { "nvim-lua/popup.nvim", lazy = true },

  -- colorful windows seperators
  { "nvim-zh/colorful-winsep.nvim", event = "VeryLazy" },

  {
    "TwIStOy/right-click.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
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

  -- alpha
  {
    "goolord/alpha-nvim",
    lazy = false,
    cond = vim.fn.argc() == 0,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = require("ht.plugrc.ui.alpha-nvim").config,
  },

  -- used for update tmux tabline
  Use {
    "edkolev/tmuxline.vim",
    lazy = { lazy = true, cmd = { "Tmuxline" } },
    functions = { FuncSpec("Update current tmux theme", "Tmuxline") },
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<M-,>", "<cmd>BufferLineCyclePrev<CR>" },
      { "<M-.>", "<cmd>BufferLineCycleNext<CR>" },
      { "<M-<>", "<cmd>BufferLineMovePrev<CR>" },
      { "<M->>", "<cmd>BufferLineMoveNext<CR>" },
    },
    config = function()
      require("bufferline").setup {
        options = {
          view = "multiwindow",
          sort_by = "insert_after_current",
          themable = true,
          hover = { enabled = true, delay = 200 },
          separator_style = "slant",
          close_command = "BDelete! %d",
          numbers = "none",
          diagnostics = "nvim_lsp",
          indicator = {
            style = "underline",
          },
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              highlight = "Directory",
            },
          },
        },
      }
    end,
  },
}
