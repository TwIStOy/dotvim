---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.golang",
  deps = {
    "coding",
    "lsp",
    "treesitter",
    "ui",
    "editor",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "go" })
        end
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "gopls",
          "goimports",
          "gofumpt",
        })
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            gopls = {
              settings = {
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
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          go = { "goimports", "gofumpt" },
        },
      },
    },
  },
}
