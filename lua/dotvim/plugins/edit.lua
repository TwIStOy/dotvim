---@module "dotvim.plugins.edit"

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
    "altermo/ultimate-autopair.nvim",
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    opts = {
      close = {
        map = "<C-0>",
        cmap = "<C-0>",
      },
      tabout = {
        hopout = true,
      },
      fastwarp = {
        enable = true,
        map = "<C-=>",
        rmap = "<C-->",
        cmap = "<C-=>",
        crmap = "<C-->",
        enable_normal = true,
        enable_reverse = true,
        hopout = false,
        multiline = true,
        nocursormove = true,
        no_nothing_if_fail = false,
      },
      config_internal_pairs = {
        {
          '"',
          '"',
          suround = true,
          cond = function(fn, o)
            -- vim
            if
              fn.get_ft() == "vim"
              and (
                o.line:sub(1, o.col - 1):match("^%s*$") ~= nil
                or o.line:sub(o.col - 1, o.col - 1) == "@"
              )
            then
              return false
            end

            -- luasnip-snippets expands `#"` in cpp
            if
              fn.get_ft() == "cpp"
              and o.line:sub(1, o.col - 1):match("^%s*#$") ~= nil
            then
              return false
            end

            return true
          end,
          multiline = false,
        },
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
}
