---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.rest",
  deps = {
    "editor",
    "treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, {
            "lua",
            "xml",
            "http",
            "json",
            "graphql",
          })
        end
      end,
    },
    {
      "rest-nvim/rest.nvim",
      dependencies = {
        "telescope.nvim",
      },
      pname = "rest-nvim",
      ft = { "http" },
      cmd = { "Rest" },
      config = function(_, opts)
        require("rest-nvim").setup(opts)
        require("telescope").load_extension("rest")
      end,
      opts = {},
    },
  },
}
