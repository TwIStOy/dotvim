---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lsp",
  deps = {
    "dora.packages.lsp",
    "dora.packages.editor",
  },
  plugins = {
    {
      "stevearc/aerial.nvim",
      dependencies = {
        "nvim-treesitter",
        "nvim-web-devicons",
        "telescope.nvim",
      },
      cmd = {
        "AerialToggle",
        "AerialOpen",
        "AerialOpenAll",
        "AerialClose",
        "AerialCloseAll",
        "AerialNext",
        "AerialPrev",
        "AerialGo",
        "AerialInfo",
        "AerialNavToggle",
        "AerialNavOpen",
        "AerialNavClose",
      },
      opts = {
        backends = { "lsp", "markdown", "man" },
        layout = {
          default_direction = "right",
          placement = "edge",
          preserve_equality = true,
        },
        attach_mode = "global",
        filter_kind = false,
        show_guides = true,
      },
      config = function(_, opts)
        require("aerial").setup(opts)
        require("telescope").load_extension("aerial")
      end,
    },
  },
}
