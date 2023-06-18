return {
  -- measure startuptime
  Use {
    "dstein64/vim-startuptime",
    lazy = {
      cmd = "StartupTime",
      config = function()
        vim.g.startuptime_tries = 10
      end,
    },
    category = "VimStartuptime",
    functions = { FuncSpec("Show startup time", "StartupTime") },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy", lazy = true },

  Use {
    "wakatime/vim-wakatime",
    lazy = {
      event = "BufRead",
    },
    category = "WakaTime",
    functions = {
      FuncSpec("Echo total coding activity for Today", "WakaTimeToday"),
      FuncSpec(
        "Enable debug mode (may slow down Vim so disable when finished debugging)",
        "WakaTimeDebugEnable"
      ),
      FuncSpec("Disable debug mode", "WakaTimeDebugDisable"),
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "MunifTanjim/nui.nvim", lazy = true },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = { input = { title_pos = "center", relative = "editor" } },
    init = function()
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Better `vim.notify()`
  Use {
    "rcarriga/nvim-notify",
    functions = {
      FuncSpec("List notify histories using telescope", function()
        require("telescope").extensions.notify.notify()
      end, {
        keys = "<leader>lh",
        desc = "notify-history",
      }),
      FuncSpec("Dismiss all notifications", function()
        require("notify").dismiss { silent = true, pending = true }
      end, {
        keys = "<leader>nn",
        desc = "notify-history",
      }),
    },
    lazy = {
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        timeout = 3000,
        stages = "static",
        fps = 1,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      },
    },
  },

  {
    "TwIStOy/nvim-lastplace",
    event = "BufReadPre",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = false,
    },
  },

  -- noicer ui
  Use {
    "folke/noice.nvim",
    lazy = {
      lazy = true,
      event = "VeryLazy",
      dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
      enabled = function()
        if vim.g["neovide"] or vim.g["fvim_loaded"] then
          return false
        end
        return true
      end,
      opts = {
        lsp = {
          progress = { enabled = false, throttle = 1000 / 10 },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false,
            auto_open = {
              enabled = true,
              trigger = true,
              luasnip = true,
              throttle = 50,
            },
          },
        },
        messages = { enabled = false },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      },
      config = function(_, opts)
        vim.defer_fn(function()
          require("noice").setup(opts)
        end, 20)
      end,
    },
    functions = {
      FuncSpec("Shows the message history", "Noice history"),
      FuncSpec("Shows the last message in a popup", "Noice last"),
      FuncSpec("Dismiss all visible messages", "Noice dismiss"),
      FuncSpec("Disables Noice", "Noice disable"),
      FuncSpec("Enables Noice", "Noice enable"),
      FuncSpec("Show debugging stats", "Noice stats"),
      FuncSpec("Opens message history in Telescope", "Noice telescope"),
      FuncSpec("Shows the error messages in a split", "Noice errors"),
    },
  },
}
