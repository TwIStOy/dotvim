---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.toml",
  deps = {
    "coding",
    "lsp",
    "treesitter",
    "editor",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "toml" })
        end
      end,
    },
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        opts.servers.opts.taplo = {}
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "taplo",
        })
      end,
    },
  },
}
