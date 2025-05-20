---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.bash",
  deps = {
    "coding",
    "lsp",
    "treesitter",
    "editor",
  },
  plugins = {
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "shellcheck",
        })
      end,
    },
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufNewFile" },
      opts = function(_, opts)
        opts.linters_by_ft.bash = { "shellcheck" }
      end,
    },
  },
}
