---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.nix",
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
          vim.list_extend(opts.ensure_installed, { "nix" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            nil_ls = {
              settings = {
                ["nil"] = {
                  formatting = {
                    command = { "alejandra" },
                  },
                  nix = {
                    maxMemoryMB = 16 * 1024,
                    flake = {
                      autoArchive = true,
                      autoEvalInputs = true,
                    },
                  },
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
          nix = { "alejandra" },
        },
      },
    },
  },
}
