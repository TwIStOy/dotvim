---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.cmake",
  deps = {
    "coding",
    "lsp",
    "treesitter",
    "editor",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "cmake" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            cmake = {
              initializationOptions = { buildDirectory = "build" },
            },
          },
        },
      },
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          cmake = { "gersemi" },
        },
      },
    },
    {
      "dial.nvim",
      opts = function(_, opts)
        local function define_custom(...)
          local augend = require("dial.augend")
          return augend.constant.new {
            elements = { ... },
            word = true,
            cyclic = true,
          }
        end

        if opts.ft.cmake == nil then
          opts.ft.cmake = {}
        end

        vim.list_extend(opts.ft.cmake, {
          define_custom("on", "off"),
          define_custom("ON", "OFF"),
        })
      end,
    },
  },
}
