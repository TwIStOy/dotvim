---@type dora.core.plugin.PluginOption
return {
  "monaqa/dial.nvim",
  gui = "all",
  event = { "BufReadPost" },
  keys = {
    {
      "<C-a>",
      desc = "dial inc",
      mode = { "n", "v" },
    },
    {
      "<C-x>",
      desc = "dial dec",
      mode = { "n", "v" },
    },
  },
  opts = function()
    local augend = require("dial.augend")

    local function define_custom(...)
      return augend.constant.new {
        elements = { ... },
        word = true,
        cyclic = true,
      }
    end

    local opts = {}

    opts.commons = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.binary,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%Y-%m-%d"],
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

    opts.ft = {
      cpp = {
        define_custom("Debug", "Info", "Warn", "Error", "Fatal"),
        define_custom("first", "second"),
        define_custom("true_type", "false_type"),
        define_custom("uint8_t", "uint16_t", "uint32_t", "uint64_t"),
        define_custom("int8_t", "int16_t", "int32_t", "int64_t"),
        define_custom("htonl", "ntohl"),
        define_custom("htons", "ntohs"),
        define_custom("ASSERT_EQ", "ASSERT_NE"),
        define_custom("EXPECT_EQ", "EXPECT_NE"),
        define_custom("==", "!="),
        define_custom("static_cast", "dynamic_cast", "reinterpret_cast"),
        define_custom("private", "public", "protected"),
      },
      python = { define_custom("True", "False") },
      lua = { define_custom("==", "~=") },
      cmake = {
        define_custom("on", "off"),
        define_custom("ON", "OFF"),
      },
      toml = { augend.semver.alias.semver },
    }

    return opts
  end,
  config = function(_, opts)
    local groups = {}
    for ft, ft_opts in pairs(opts.ft) do
      groups[ft] = {
        unpack(opts.commons),
        unpack(ft_opts),
      }
    end
    require("dial.config").augends:register_group(groups)

    vim.keymap.set({ "n", "v" }, "<C-a>", require("dial.map").inc_normal(), {
      desc = "dial inc",
    })
    vim.keymap.set({ "n", "v" }, "<C-x>", require("dial.map").dec_normal(), {
      desc = "dial dec",
    })

    for ft, _ in pairs(opts.ft) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
          vim.keymap.set(
            { "n", "v" },
            "<C-a>",
            require("dial.map").inc_normal(ft),
            {
              desc = "dial inc",
            }
          )
          vim.keymap.set(
            { "n", "v" },
            "<C-x>",
            require("dial.map").dec_normal(ft),
            {
              desc = "dial dec",
            }
          )
        end,
      })
    end
  end,
}
