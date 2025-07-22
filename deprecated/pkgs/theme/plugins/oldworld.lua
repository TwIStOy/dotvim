---@type dotvim.core.plugin.PluginOption
return {
  "dgox16/oldworld.nvim",
  lazy = true,
  opts = {
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      conditionals = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
    integrations = { -- You can disable/enable integrations
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        hop = true,
        indent_blankline = false,
        lazy = true,
        lsp = true,
        markdown = true,
        mason = true,
        navic = false,
        neo_tree = false,
        neorg = false,
        noice = true,
        notify = true,
        rainbow_delimiters = false,
        telescope = true,
        treesitter = true,
    },
  },
}
