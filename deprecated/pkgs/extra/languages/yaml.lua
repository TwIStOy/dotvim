---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.yaml",
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
          vim.list_extend(opts.ensure_installed, { "yaml" })
        end
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "yaml-language-server",
        })
      end,
    },
    {
      "b0o/schemastore.nvim",
      lazy = true,
    },
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        opts.servers.opts.yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        }
      end,
    },
  },
}
