---@type dora.core.package.PackageOption
return {
  name = "extra.lang.cmake",
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
  },
}
