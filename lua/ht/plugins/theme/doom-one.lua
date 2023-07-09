return {
  "NTBBloodbath/doom-one.nvim",
  enabled = false,
  priority = 1000,
  init = function()
    vim.g.doom_one_cursor_coloring = true
    vim.g.doom_one_terminal_colors = true
    vim.g.doom_one_italic_comments = true
    vim.g.doom_one_enable_treesitter = true
    vim.g.doom_one_diagnostics_text_color = false
    vim.g.doom_one_transparent_background = false

    -- Pumblend transparency
    vim.g.doom_one_pumblend_enable = false

    -- Plugins integration
    vim.g.doom_one_plugin_neorg = false
    vim.g.doom_one_plugin_barbar = false
    vim.g.doom_one_plugin_telescope = true
    vim.g.doom_one_plugin_neogit = false
    vim.g.doom_one_plugin_nvim_tree = true
    vim.g.doom_one_plugin_dashboard = false
    vim.g.doom_one_plugin_startify = true
    vim.g.doom_one_plugin_whichkey = true
    vim.g.doom_one_plugin_indent_blankline = true
    vim.g.doom_one_plugin_vim_illuminate = false
    vim.g.doom_one_plugin_lspsaga = true
  end,
  config = function()
    vim.cmd("colorscheme doom-one")
  end,
}
