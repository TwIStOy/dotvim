---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.python",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
    "dora.packages.treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "python" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            pyright = {},
          },
        },
      },
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          python = { "black" },
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

        if opts.ft.python == nil then
          opts.ft.python = {}
        end

        vim.list_extend(opts.ft.python, {
          define_custom("True", "False"),
        })
      end,
    },
  },
}
