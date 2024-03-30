---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.nix",
  deps = {
    "coding",
    "lsp",
    "treesitter",
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
      "nvim-lint",
      opts = {
        linters_by_ft = {
          nix = { "statix" },
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
