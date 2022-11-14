local M = {}

M.core = {
  'lukas-reineke/indent-blankline.nvim',
  requires = { 'nvim-treesitter/nvim-treesitter' },
  event = 'BufReadPost',
}

M.config = function() -- code to run after plugin loaded
  vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

  require("indent_blankline").setup {
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,
    context_highlight_list = { 'IndentBlanklineIndent3' },
    context_char_list = {'▏'},
    char = '▏',

    bufname_exclude = { '' },
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

