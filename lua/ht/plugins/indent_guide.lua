local M = {}

M.core = {
  'lukas-reineke/indent-blankline.nvim',
  requires = { 'nvim-treesitter/nvim-treesitter' },
}

M.config = function() -- code to run after plugin loaded
  require("indent_blankline").setup {
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,
    context_highlight_list = { 'Blue' },

    bufname_exclude = { '' },
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

