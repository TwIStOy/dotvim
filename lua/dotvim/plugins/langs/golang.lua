---@type LazyPluginSpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        gopls = {
          setttings = {
            gopls = {},
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      return require("dotvim.commons").option.deep_merge(opts, {
        extra = {
          ensure_installed = {
            "gopls",
            "goimports",
            "gofumpt",
          },
        },
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    ft = { "go" },
    opts = function(_, opts)
      local augend = require("dial.augend")

      local function define_custom(...)
        return augend.constant.new {
          elements = { ... },
          word = true,
          cyclic = true,
        }
      end

      opts = opts or {}
      opts.language_configs = opts.language_configs or {}

      opts.language_configs.go = {
        define_custom("int8", "int16", "int32", "int64"),
      }
    end,
  },
}
