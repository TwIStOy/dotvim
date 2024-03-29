---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.swift",
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
          vim.list_extend(opts.ensure_installed, { "swift" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            sourcekit = {},
          },
          setup = {
            sourcekit = function(_, server_opts)
              if vim.uv.os_uname().sysname == "Darwin" then
                -- skip if not on macOS
                require("lspconfig").sourcekit.setup(server_opts)
              end
            end,
          },
        },
      },
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          swift = { "swift_format" },
        },
      },
    },
  },
}
