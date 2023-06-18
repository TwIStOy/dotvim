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
}
