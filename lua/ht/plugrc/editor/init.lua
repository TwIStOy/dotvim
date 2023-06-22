return {
  { import = "ht.plugrc.editor" },

  -- vim-surround
  {
    "tpope/vim-surround",
    event = "BufReadPost",
    init = function()
      vim.g.surround_no_mappings = 0
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  -- fast move
  {
    "matze/vim-move",
    keys = {
      { "<C-h>", nil, mode = { "n", "v" } },
      { "<C-j>", nil, mode = { "n", "v" } },
      { "<C-k>", nil, mode = { "n", "v" } },
      { "<C-l>", nil, mode = { "n", "v" } },
    },
    init = function()
      vim.g.move_key_modifier = "C"
      vim.g.move_key_modifier_visualmode = "C"
    end,
  },

  -- resolve git conflict
  Use {
    "akinsho/git-conflict.nvim",
    lazy = {
      lazy = true,
      config = true,
      opts = {
        default_mappings = false,
      },
    },
    category = "GitConflict",
    functions = {
      {
        filter = {
          filter = require("ht.core.const").not_in_common_excluded,
        },
        values = {
          FuncSpec("Select the current changes", "GitConflictChooseOurs", {
            keys = { "<leader>v1" },
            desc = "select-ours",
          }),
          FuncSpec("Select the incoming changes", "GitConflictChooseTheirs", {
            keys = { "<leader>v2" },
            desc = "select-them",
          }),
          FuncSpec("Select both changes", "GitConflictChooseBoth", {
            keys = { "<leader>vb" },
            desc = "select-both",
          }),
          FuncSpec("Select none of the changes", "GitConflictChooseNone"),
          FuncSpec("Move to the next conflict", "GitConflictNextConflict"),
          FuncSpec("Move to the previous conflict", "GitConflictPrevConflict"),
        },
      },
    },
  },

  -- big J
  {
    "osyo-manga/vim-jplus",
    event = "BufReadPost",
    keys = { { "J", "<Plug>(jplus)", mode = { "n", "v" }, noremap = false } },
  },

  -- tabular
  { "godlygeek/tabular", cmd = { "Tabularize" } },
  {
    "junegunn/vim-easy-align",
    cmd = { "EasyAlign" },
    dependencies = { "godlygeek/tabular" },
    keys = {
      { "<leader>ta", "<cmd>EasyAlign<CR>", desc = "easy-align" },
      { "<leader>ta", "<cmd>EasyAlign<CR>", mode = "x", desc = "easy-align" },
    },
  },

  -- markdown table
  Use {
    "dhruvasagar/vim-table-mode",
    lazy = {
      lazy = true,
      ft = { "markdown" },
      cmd = {
        "TableModeEnable",
        "TableModeDisable",
      },
    },
    functions = {
      FuncSpec("Enable table mode", function()
        vim.cmd("TableModeEnable")
      end),
      FuncSpec("Disable table mode", function()
        vim.cmd("TableModeDisable")
      end),
    },
  },

  -- dash, only macos supported
  Use {
    "mrjones2014/dash.nvim",
    lazy = {
      build = "make install",
      lazy = true,
      cmd = { "Dash", "DashWord" },
      cond = function()
        return vim.fn.has("macunix")
      end,
      opts = {
        dash_app_path = "/Applications/Setapp/Dash.app",
        search_engine = "google",
        file_type_keywords = {
          dashboard = false,
          NvimTree = false,
          TelescopePrompt = false,
          terminal = false,
          packer = false,
          fzf = false,
        },
      },
    },
    functions = {
      FuncSpec("Search Dash", function()
        vim.cmd("Dash")
      end),
    },
  },

  -- remove buffers
  Use {
    "kazhala/close-buffers.nvim",
    lazy = {
      lazy = true,
      cmd = { "BDelete", "BWipeout" },
      config = function()
        require("close_buffers").setup {
          filetype_ignore = {
            "dashboard",
            "NvimTree",
            "TelescopePrompt",
            "terminal",
            "toggleterm",
            "packer",
            "fzf",
          },
          preserve_window_layout = { "this" },
          next_buffer_cmd = function(windows)
            require("bufferline").cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()
            for _, window in ipairs(windows) do
              vim.api.nvim_win_set_buf(window, bufnr)
            end
          end,
        }
      end,
    },
    category = "CloseBuffer",
    functions = {
      FuncSpec("Delete all non-visible buffers", function()
        require("close_buffers").delete { type = "hidden", force = true }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end, {
        keys = "<leader>ch",
        desc = "clear-hidden-buffers",
      }),
      FuncSpec("Delete all buffers without name", function()
        require("close_buffers").delete { type = "nameless" }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
      FuncSpec("Delete the current buffer", function()
        require("close_buffers").delete { type = "this" }
        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
      FuncSpec("Delete all buffers matching the regex", function()
        vim.ui.input({ prompt = "Regex" }, function(input)
          if input ~= nil then
            if #input > 0 then
              require("close_buffers").delete { regex = input }
            end
          end
        end)

        vim.cmd("redrawtabline")
        vim.cmd("redraw")
      end),
    },
  },

  -- hlsearch
  {
    "kevinhwang91/nvim-hlslens",
    lazy = true,
    config = function()
      require("hlslens").setup {
        calm_down = false,
        nearest_only = false,
        nearest_float_when = "never",
      }
    end,
    keys = {
      { "*", "*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
    },
  },

  -- session management
  Use {
    "jedrzejboczar/possession.nvim",
    lazy = {
      cmd = {
        "SSave",
        "SLoad",
        "SDelete",
        "SList",
      },
      dependencies = { "nvim-lua/plenary.nvim" },
      lazy = true,
      opts = {
        silent = true,
        commands = {
          save = "SSave",
          load = "SLoad",
          delete = "SDelete",
          list = "SList",
        },
      },
    },
    functions = {
      FuncSpec("Save session", "SSave"),
      FuncSpec("Load session", "SLoad"),
      FuncSpec("Delete session", "SDelete"),
      FuncSpec("List sessions", "SList"),
    },
  },

  -- linediff
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },

  -- post code to 0x0.st
  {
    "rktjmp/paperplanes.nvim",
    lazy = true,
    cmd = { "PP" },
    config = function()
      require("paperplanes").setup {
        register = "+",
        provider = "0x0.st",
        provider_options = {},
        notifier = vim.notify or print,
      }
    end,
  },

  -- motion
  Use {
    "phaazon/hop.nvim",
    lazy = {
      cmd = {
        "HopWord",
        "HopPattern",
        "HopChar1",
        "HopChar2",
        "HopLine",
        "HopLineStart",
      },
      opts = { keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 },
    },
    functions = {
      FuncSpec(
        "Jump to word",
        "HopWord",
        { keys = { "s", ",," }, desc = "jump-to-word" }
      ),
      FuncSpec(
        "Jump to line",
        "HopLine",
        { keys = ",l", desc = "jump-to-line" }
      ),
    },
  },

  -- motion in line with f/F
  Use {
    "jinh0/eyeliner.nvim",
    lazy = {
      cmd = { "EyelinerEnable", "EyelinerDisable", "EyelinerToggle" },
      keys = {
        { "f", nil, mode = { "n" } },
        { "F", nil, mode = { "n" } },
        { "t", nil, mode = { "n" } },
        { "T", nil, mode = { "n" } },
      },
      opts = { highlight_on_key = true, dim = true },
      config = true,
    },
    functions = {
      {
        filter = {
          filter = require("ht.core.const").not_in_common_excluded,
        },
        values = {
          FuncSpec("Enable Eyeliner", "EyelinerEnable"),
          FuncSpec("Disable Eyeliner", "EyelinerDisable"),
          FuncSpec("Toggle Eyeliner", "EyelinerToggle"),
        },
      },
    },
  },
}
