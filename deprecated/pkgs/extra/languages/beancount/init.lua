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
      "blink.cmp",
      opts = function(_, opts)
        opts.sources.default[#opts.sources.default + 1] = "beancount"
        if opts.sources.providers == nil then
          opts.sources.providers = {}
        end
        opts.sources.providers.beancount = {
          name = "beancount",
          module = "dotvim.pkgs.extra.languages.beancount.blink",
          score_offset = 100,
          async = true,
        }
      end,
    },
  },
}
