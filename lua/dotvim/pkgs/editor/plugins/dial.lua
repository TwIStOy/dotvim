---@type dotvim.core.plugin.PluginOption
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
