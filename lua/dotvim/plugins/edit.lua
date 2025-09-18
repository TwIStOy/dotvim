local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      update_debounce = 100,
    },
  },
  {
    "windwp/nvim-projectconfig",
    event = "VeryLazy",
    opts = {
      project_dir = "~/.config/nvim-projectconfig/",
      silent = false,
      project_config = {},
    },
  },
  {
    "numToStr/Comment.nvim",
    enabled = not vim.g.vscode,
    keys = {
      { "gcc", desc = "toggle-line-comment" },
      { "gcc", mode = "x", desc = "toggle-line-comment" },
      { "gbc", desc = "toggle-block-comment" },
      { "gbc", mode = "x", desc = "toggle-block-comment" },
    },
    opts = {
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gcc", block = "gbc" },
      mappings = { basic = true, extra = false },
    },
  },
  {
    "mfussenegger/nvim-lint",
    enabled = not vim.g.vscode,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft

      local used_linters = {}
      for _, linter in pairs(opts.linters_by_ft) do
        if type(linter) == "string" then
          used_linters[#used_linters + 1] = linter
        else
          for _, l in pairs(linter) do
            used_linters[#used_linters + 1] = l
          end
        end
      end

      for _, name in pairs(used_linters) do
        local linter = require("lint").linters[name]
        if linter == nil then
          error("Linter " .. name .. " not found")
        end
        local exe = Commons.which(linter.cmd)
        if exe ~= nil then
          linter.cmd = exe
        end
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "phaazon/hop.nvim",
    cmd = {
      "HopWord",
      "HopPattern",
      "HopChar1",
      "HopChar2",
      "HopLine",
      "HopLineStart",
    },
    opts = { keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 },
    keys = {
      {
        ",l",
        "<cmd>HopLine<cr>",
        desc = "jump-to-line",
      },
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" }, desc = "dial-inc" },
      { "<C-x>", mode = { "n", "v" }, desc = "dial-dec" },
    },
    opts = {},
    config = function(_, opts)
      local augend = require("dial.augend")

      local function define_custom(...)
        return augend.constant.new {
          elements = { ... },
          word = true,
          cyclic = true,
        }
      end

      local commons = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%H:%M"],
        define_custom("true", "false"),
        define_custom("yes", "no"),
        define_custom("YES", "NO"),
        define_custom("||", "&&"),
        define_custom("enable", "disable"),
        define_custom(
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday"
        ),
        define_custom(
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ),
      }

      local groups = {
        default = commons,
      }

      -- Collect language-specific configurations from opts
      if opts.language_configs then
        for lang, lang_augends in pairs(opts.language_configs) do
          groups[lang] = vim.list_extend(vim.deepcopy(commons), lang_augends)
        end
      end

      require("dial.config").augends:register_group(groups)

      vim.keymap.set({ "n", "v" }, "<C-a>", function()
        require("dial.map").manipulate("increment", "normal")
      end, { desc = "dial-inc" })

      vim.keymap.set({ "n", "v" }, "<C-x>", function()
        require("dial.map").manipulate("decrement", "normal")
      end, { desc = "dial-dec" })

      -- Configure filetype-specific augends
      if opts.language_configs then
        for filetype, _ in pairs(opts.language_configs) do
          vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype,
            callback = function()
              vim.keymap.set({ "n", "v" }, "<C-a>", function()
                require("dial.map").manipulate("increment", "normal", filetype)
              end, { desc = "dial-inc", buffer = true })

              vim.keymap.set({ "n", "v" }, "<C-x>", function()
                require("dial.map").manipulate("decrement", "normal", filetype)
              end, { desc = "dial-dec", buffer = true })
            end,
          })
        end
      end
    end,
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
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        title_pos = "center",
        relative = "editor",
        insert_only = true,
        start_in_insert = true,
      },
    },
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
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    opts = function()
      return {
        mapping = {
          ["toggle_line"] = {
            cmd = false,
          },
          ["send_to_qf"] = {
            cmd = false,
          },
          ["run_current_replace"] = {
            cmd = false,
          },
          ["run_replace"] = {
            cmd = false,
          },
        },
        find_engine = {
          ["rg"] = {
            cmd = dv.which("rg"),
          },
          ["ag"] = {
            cmd = dv.which("ag"),
          },
        },
        replace_engine = {
          ["sed"] = {
            cmd = dv.which("sed"),
          },
          ["oxi"] = {
            cmd = dv.which("oxi"),
          },
          ["sd"] = {
            cmd = dv.which("sd"),
          },
        },
        live_update = true,
      }
    end,
    config = true,
  },
}
