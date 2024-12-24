---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.beancount",
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
          vim.list_extend(opts.ensure_installed, { "beancount" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            beancount = {
              settings = {},
            },
          },
        },
      },
    },
  },
}
