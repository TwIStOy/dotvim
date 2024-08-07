---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.swift",
  deps = {
    "coding",
    "editor",
    "lsp",
    "treesitter",
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
              ---@diagnostic disable-next-line: undefined-field
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
