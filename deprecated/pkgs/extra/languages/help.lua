---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.help",
  deps = {
    "coding",
    "lsp",
    "editor",
    "treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "vimdoc" })
        end
      end,
    },
    {
      "OXY2DEV/helpview.nvim",
      ft = "help",
    },
  },
}
