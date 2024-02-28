---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.cmake",
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
          if vim.list_contains(opts.ensure_installed, "cmake") then
            return
          end
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
          cpp = { "gersemi" },
        },
      },
    },
  },
}
