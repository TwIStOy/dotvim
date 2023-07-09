return {
  "projekt0n/github-nvim-theme",
  enabled = false,
  opts = {
    options = {
      styles = {
        comments = "italic",
        conditionals = "italic",
        keywords = "bold",
        loops = "bold",
      },
      darken = {
        floats = true,
        sidebars = {
          enable = true,
          list = {
            "NvimTree",
          },
        },
      },
    },
    palettes = {
      all = {
        mauve = { base = "#CBA6F7" },
        teal = { base = "#94E2D5" },
        flamingo = { base = "#F2CDCD" },
        peach = { base = "#FAB387" },
      },
    },
    groups = {
      all = {
        ["@lsp.typemod.variable.mutable.rust"] = { style = "underline" },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = {
          style = "underline",
        },
        ["@variable.builtin"] = { style = "italic" },
      },
    },
  },
  config = function(_, opts)
    require("github-theme").setup(opts)
    vim.cmd("colorscheme github_dark")
  end,
}
