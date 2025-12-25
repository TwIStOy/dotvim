---@type LazyPluginSpec
return {
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
}
