return {
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = function() -- code to run after plugin loaded
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

      return {
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        context_highlight_list = { 'IndentBlanklineIndent3' },
        context_char_list = { '▏' },
        char = '▏',

        bufname_exclude = { '' },
        filetype_exclude = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy"
        },
      }
    end,
  },
}
