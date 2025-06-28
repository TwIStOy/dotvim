---@type LazyPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      return require("dotvim.commons").option.deep_merge(opts, {
        extra = {
          ensure_installed = {
            "nil",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        nil_ls = {
          setttings = {
            formatting = {
              command = { "alejandra" },
            },
            nix = {
              maxMemoryMB = 2 * 1024,
              flake = {
                autoArchive = true,
                autoEvalInputs = false,
              },
            },
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        nix = { "statix" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
  },
}
