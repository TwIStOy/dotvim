---@type LazyPluginSpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        gopls = {
          setttings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
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
}
