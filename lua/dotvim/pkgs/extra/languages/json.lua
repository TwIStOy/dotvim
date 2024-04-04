---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.json",
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
          vim.list_extend(opts.ensure_installed, { "json", "jsonc", "jsonnet" })
        end
      end,
    },
    {
      "b0o/schemastore.nvim",
      lazy = true,
    },
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        opts.servers.opts.jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        }
      end,
    },
  },
}
